SolidusPaypalCommercePlatform.postOrder = function(payment_method_id) {
  return Spree.ajax({
    url: '/solidus_paypal_commerce_platform/orders',
    method: 'POST',
    data: {
      payment_method_id: payment_method_id,
      order_id: Spree.current_order_id,
      order_token: Spree.current_order_token
    }
  }).then(function(response) {
    return response.table.id;
  })
}

SolidusPaypalCommercePlatform.approveOrder = function(data, actions) {
  actions.order.get().then(function(response){
    SolidusPaypalCommercePlatform.updateAddress(response).then(function() {
      $("#payments_source_paypal_order_id").val(data.orderID)
      $("#payments_source_paypal_email").val(response.payer.email_address)
      $("#checkout_form_payment").submit()
    })
  })
}

SolidusPaypalCommercePlatform.shippingChange = function(data, actions) {
  Spree.ajax({
    url: '/solidus_paypal_commerce_platform/shipping_rates',
    method: 'GET',
    data: {
      order_id: Spree.current_order_id,
      order_token: Spree.current_order_token,
      address: data.shipping_address
    },
    error: function(response) {
      message = response.responseJSON;
      console.log('There were some problems with your payment address - ' + message);
      actions.reject()
    }
  }).then(function(response) {
    actions.order.patch([response]);
  });
}

SolidusPaypalCommercePlatform.finalizeOrder = function(payment_method_id, data, actions) {
  actions.order.get().then(function(response){
    SolidusPaypalCommercePlatform.updateAddress(response).then(function() {
      var paypal_amount = response.purchase_units[0].amount.value
      SolidusPaypalCommercePlatform.addPayment(paypal_amount, payment_method_id, data, response.payer.email_address).then(function() {
        SolidusPaypalCommercePlatform.advanceOrder().then(function(response) {
          window.location.href = SolidusPaypalCommercePlatform.checkout_url
        })
      })
    })
  })
}

SolidusPaypalCommercePlatform.advanceOrder = function() {
  return Spree.ajax({
    url: '/api/checkouts/' + Spree.current_order_id + '/advance',
    method: 'PUT',
    data: {
      order_token: Spree.current_order_token
    },
    error: function(response) {
      alert('There were some problems with your order');
    }
  })
}

SolidusPaypalCommercePlatform.addPayment = function(paypal_amount, payment_method_id, data, email) {
  return Spree.ajax({
    url: '/api/checkouts/' + Spree.current_order_id + '/payments',
    method: 'POST',
    data: {
      order_token: Spree.current_order_token,
      payment: {
        amount: paypal_amount,
        payment_method_id: payment_method_id,
        source_attributes: {
          paypal_order_id: data.orderID,
          paypal_email: email
        }
      }
    },
    error: function(response) {
      alert('There were some problems with your payment');
    }
  })
}

SolidusPaypalCommercePlatform.updateAddress = function(response) { 
  var updated_address = response.purchase_units[0].shipping.address
  return Spree.ajax({
    url: '/solidus_paypal_commerce_platform/update_address',
    method: 'POST',
    data: {
      address: {
        updated_address: updated_address,
        recipient: response.payer
      },
      order_id: Spree.current_order_id,
      order_token: Spree.current_order_token
    },
    error: function(response) {
      message = response.responseJSON;
      alert('There were some problems with your payment address - ' + message);
    }
  })
}
