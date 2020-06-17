SolidusPaypalCommercePlatform.renderButton = function(payment_method_id, style) {
  paypal.Buttons({
    style: style,
    createOrder: function (data, actions) {
      return SolidusPaypalCommercePlatform.postOrder(payment_method_id);
    },
    onApprove: function (data, actions) {
      return SolidusPaypalCommercePlatform.approveOrder(data, actions);
    },
    onShippingChange: function(data, actions) {
      return SolidusPaypalCommercePlatform.shippingChange(data, actions);
    }
  }).render('#paypal-button-container')
}
