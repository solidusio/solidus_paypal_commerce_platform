SolidusPaypalCommercePlatform.postOrder = function(payment_method_id) {
  return Spree.ajax({
    url: '/solidus_paypal_commerce_platform/orders',
    method: 'POST',
    data: {
      payment_method_id: payment_method_id,
      order_id: Spree.current_order_id,
      order_token: Spree.current_order_token
    }
  }).then(function(res) {
    return res.table.id;
  })
}

SolidusPaypalCommercePlatform.approveOrder = function(data, actions) {
  actions.order.get().then(function(res){
    var updated_address = res.purchase_units[0].shipping.address
    Spree.ajax({
      url: '/solidus_paypal_commerce_platform/update_address',
      method: 'POST',
      data: {
        address: updated_address,
        order_id: Spree.current_order_id,
        order_token: Spree.current_order_token
      },
      error: function(response) {
        message = response.responseJSON;
        alert('There were some problems with your payment address - ' + message);
      }
    }).then(function() {
      $("#payments_source_paypal_order_id").val(data.orderID)
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
  }).then(function(res) {
    actions.order.patch([res]);
  });
}
