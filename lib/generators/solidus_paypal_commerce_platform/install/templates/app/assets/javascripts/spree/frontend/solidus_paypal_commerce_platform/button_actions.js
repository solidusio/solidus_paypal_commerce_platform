// Attach inline GET-compatible params to a path.
// The path is assumed to be base off the current location.
// The data structure will wrap keys beyond the first level in
// square brackets, e.g. `{a: {b: 123}}` will become `a[b]=123`.
const urlWithParams = (path, data) => {
  const url = new URL(path, window.location)

  const formKey = (keys) => {
    if (keys.length === 0) return ''
    if (keys.length === 1) return keys[0]

    // Wrap any key beyond the first one in square brackets
    return `${keys.shift()}${keys.map((k) => `[${k}]`).join()}`
  }

  const appendSearchParams = (parentKeys, data) =>
    Object.entries(data).forEach(([key, value]) => {

      if (typeof value === 'object')
        appendSearchParams([...parentKeys, key], value)
      else
        url.searchParams.append(formKey([...parentKeys, key]), value)
    })

  appendSearchParams([], data)
  return url
}

const authHeader = (options = {}) => {
  const apiKey = SolidusPaypalCommercePlatform.api_key
  if (options.require && !apiKey) throw new Error("Missing api key")


  return {
    'Authorization': `Bearer ${apiKey}`,
    [document.querySelector('meta[name="csrf-param"]')?.content]: document.querySelector('meta[name="csrf-token"]')?.content,
  }
}
SolidusPaypalCommercePlatform.showOverlay = function() {
  document.getElementById("paypal_commerce_platform_overlay").style.display = "block";
}

SolidusPaypalCommercePlatform.hideOverlay = function() {
  document.getElementById("paypal_commerce_platform_overlay").style.display = "none";
}

SolidusPaypalCommercePlatform.handleError = function(error) {
  console.error(error);
  alert("There was a problem connecting with PayPal.")
  throw error
}

SolidusPaypalCommercePlatform.sendOrder = async function(payment_method_id) {
  if (!payment_method_id) throw new Error("payment_method_id is missing!")

  const url = urlWithParams(`/solidus_paypal_commerce_platform/paypal_orders/${SolidusPaypalCommercePlatform.current_order_id}`, {
    payment_method_id: payment_method_id,
    order_token: SolidusPaypalCommercePlatform.current_order_token,
  })

  const response = await fetch(url, {headers: authHeader()})
  const data = await response.json()

  if (response.ok) {
    return data.table.result.table.id
  } else {
    return data.table.error.table
  }
}

SolidusPaypalCommercePlatform.createAndSendOrder = async function(payment_method_id) {
  await SolidusPaypalCommercePlatform.createOrder()
  return await SolidusPaypalCommercePlatform.sendOrder(payment_method_id)
}

SolidusPaypalCommercePlatform.createOrder = async function() {
  const response = await fetch(
    "/solidus_paypal_commerce_platform/orders",
    {
      method: 'POST',
      headers: {
        ...authHeader(),
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        order: {
          line_items_attributes: [{
            variant_id: SolidusPaypalCommercePlatform.getVariantId(),
            quantity: SolidusPaypalCommercePlatform.getQuantity()
          }]
        }
      }),
    }
  )
  const data = await response.json()

  if (response.ok) {
    SolidusPaypalCommercePlatform.current_order_id = data.number
    SolidusPaypalCommercePlatform.current_order_token = data.guest_token
  } else {
    console.error('A problem has occurred while creating your order', data);
    alert('A problem has occurred while creating your order - ' + JSON.stringify(data))
  }
}

SolidusPaypalCommercePlatform.getVariantId = function() {
  var variants = document.getElementsByName("variant_id")
  var variant_id;

  if (variants.length == 1){
    variant_id = variants[0].value
  } else {
    for (var i = 0; i < variants.length; i++) {
      if (variants[i].checked) {
        variant_id = variants[i].value
      }
    }
  }
  return variant_id
}

SolidusPaypalCommercePlatform.getQuantity = function() {
  return document.getElementById("quantity").value
}

SolidusPaypalCommercePlatform.approveOrder = function(data, actions) {
  SolidusPaypalCommercePlatform.showOverlay()
  actions.order.get().then(function(response){
    SolidusPaypalCommercePlatform.updateAddress(response).then(function() {
      SolidusPaypalCommercePlatform.verifyTotal(response.purchase_units[0].amount.value).then(function(){
        document.querySelector("#payments_source_paypal_order_id").value = data.orderID
        document.querySelector("#payments_source_paypal_email").value = response.payer.email_address
        document.querySelector("#payments_source_paypal_funding_source").value = SolidusPaypalCommercePlatform.fundingSource
        document.querySelector("#checkout_form_payment").submit()
      })
    })
  })
}

SolidusPaypalCommercePlatform.shippingChange = async function(paypalData, actions) {
  const shipping_address = paypalData.shipping_address

  url = urlWithParams('/solidus_paypal_commerce_platform/shipping_rates', {
    order_id: SolidusPaypalCommercePlatform.current_order_id,
    order_token: SolidusPaypalCommercePlatform.current_order_token,
    address: shipping_address,
  })

  const response = await fetch(url, {headers: authHeader()})
  const data = await response.json()

  if (response.ok) {
    return actions.order.patch([data]).catch(function(e) {
      console.error('There were some problems with your payment address while trying to patch the order', e);
      actions.reject()
    })
  } else {
    console.error('There were some problems with your payment address', data);
    return actions.reject()
  }
}

SolidusPaypalCommercePlatform.verifyTotal = async function(paypal_total) {
  const response = await fetch(
    urlWithParams('/solidus_paypal_commerce_platform/verify_total', {
      order_id: SolidusPaypalCommercePlatform.current_order_id,
      order_token: SolidusPaypalCommercePlatform.current_order_token,
      paypal_total: paypal_total
    }), {
      headers: authHeader()
    })

  if (!response.ok) {
    SolidusPaypalCommercePlatform.hideOverlay()
    alert('There were some problems with your payment - ' + response.responseJSON.errors.expected_total);
  }
}

SolidusPaypalCommercePlatform.finalizeOrder = function(payment_method_id, data, actions) {
  SolidusPaypalCommercePlatform.showOverlay()
  actions.order.get().then(function(response){
    SolidusPaypalCommercePlatform.updateAddress(response).then(function() {
      var paypal_amount = response.purchase_units[0].amount.value
      SolidusPaypalCommercePlatform.advanceOrder().then(function() {
        SolidusPaypalCommercePlatform.verifyTotal(paypal_amount).then(function(){
          SolidusPaypalCommercePlatform.addPayment(paypal_amount, payment_method_id, data, response.payer.email_address).then(function() {
            window.location.href = SolidusPaypalCommercePlatform.checkout_url
          })
        })
      })
    })
  })
}

SolidusPaypalCommercePlatform.advanceOrder = async function() {
  const response = await fetch(
    `/api/checkouts/${SolidusPaypalCommercePlatform.current_order_id}/advance`, {
      headers: {
        ...authHeader(),
        'Content-Type': 'application/json'
      },
      method: 'PUT',
      body: JSON.stringify({
        order_token: SolidusPaypalCommercePlatform.current_order_token
      })
    })

  if (!response.ok) {
    SolidusPaypalCommercePlatform.hideOverlay()
    alert('There were some problems with your order');
  }
}

SolidusPaypalCommercePlatform.addPayment = async function(paypal_amount, payment_method_id, data, email) {
  const response = await fetch(
    `/api/checkouts/${SolidusPaypalCommercePlatform.current_order_id}/payments`, {
    method: 'POST',
      headers: {
        ...authHeader(),
        'Content-Type': 'application/json'
      },
    body: JSON.stringify({
      order_token: SolidusPaypalCommercePlatform.current_order_token,
      payment: {
        amount: paypal_amount,
        payment_method_id: payment_method_id,
        source_attributes: {
          paypal_order_id: data.orderID,
          paypal_email: email,
          paypal_funding_source: SolidusPaypalCommercePlatform.fundingSource
        }
      }
    })
  })

  if (!response.ok) {
    SolidusPaypalCommercePlatform.hideOverlay()
    alert('There were some problems with your payment');
  }
}

SolidusPaypalCommercePlatform.updateAddress = async function(payload) {
  var shipping = payload.purchase_units[0].shipping
  if (!shipping) return Promise.resolve({})

  var updated_address = shipping.address

  const response = await fetch(
    '/solidus_paypal_commerce_platform/update_address', {
      method: 'POST',
      headers: {
        ...authHeader(),
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        address: {
          updated_address: updated_address,
          recipient: payload.payer
        },
        order_id: SolidusPaypalCommercePlatform.current_order_id,
        order_token: SolidusPaypalCommercePlatform.current_order_token
      }),
    }
  )

  if (!response.ok) {
    SolidusPaypalCommercePlatform.hideOverlay()
    const message = await response.text()
    console.error('There were some problems with your payment address - ', message);
    alert('There were some problems with your payment address - ' + message)
  }
}
