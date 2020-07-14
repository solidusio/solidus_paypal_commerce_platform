SolidusPaypalCommercePlatform.renderButton = function(payment_method_id, style) {
  paypal.Buttons({
    style: style,
    createOrder: SolidusPaypalCommercePlatform.sendOrder.bind(null, payment_method_id),
    onApprove: SolidusPaypalCommercePlatform.approveOrder,
    onShippingChange: SolidusPaypalCommercePlatform.shippingChange
  }).render('#paypal-button-container')
}

SolidusPaypalCommercePlatform.renderCartButton = function(payment_method_id, style) {
  paypal.Buttons({
    style: style,
    createOrder: SolidusPaypalCommercePlatform.sendOrder.bind(null, payment_method_id),
    onApprove: SolidusPaypalCommercePlatform.finalizeOrder.bind(null, payment_method_id),
    onShippingChange: SolidusPaypalCommercePlatform.shippingChange
  }).render('#paypal-button-container')
}

SolidusPaypalCommercePlatform.renderProductButton = function(payment_method_id, style) {
  paypal.Buttons({
    style: style,
    createOrder: SolidusPaypalCommercePlatform.createAndSendOrder.bind(null, payment_method_id),
    onApprove: SolidusPaypalCommercePlatform.finalizeOrder.bind(null, payment_method_id),
    onShippingChange: SolidusPaypalCommercePlatform.shippingChange
  }).render('#paypal-button-container')
}
