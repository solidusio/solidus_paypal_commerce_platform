SolidusPaypalCommercePlatform.renderButton = function(payment_method_id, style) {
  paypal.Buttons({
    style: style,
    createOrder: function (data, actions) {
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
    },
    onApprove: function (data, actions) {
      $("#payments_source_paypal_order_id").val(data.orderID)
      $("#checkout_form_payment").submit()
    },
    onShippingChange: function(data, actions) {
      Spree.ajax({
        url: '/solidus_paypal_commerce_platform/shipping_rates',
        method: 'GET',
        data: {
          order_id: Spree.current_order_id,
          order_token: Spree.current_order_token,
          address: data.shipping_address
        }
      }).then(function(res) {
        return actions.order.patch([
          res
        ]);
      });
    }
  }).render('#paypal-button-container')
}
