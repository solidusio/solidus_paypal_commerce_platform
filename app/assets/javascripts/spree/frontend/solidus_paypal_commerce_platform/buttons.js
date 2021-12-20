SolidusPaypalCommercePlatform.renderButton = function(payment_method_id, style) {
  paypal.Buttons({
    style: style,
    createOrder: SolidusPaypalCommercePlatform.sendOrder.bind(null, payment_method_id),
    onClick: (data) => { SolidusPaypalCommercePlatform.fundingSource = data.fundingSource },
    onApprove: SolidusPaypalCommercePlatform.approveOrder,
    onShippingChange: SolidusPaypalCommercePlatform.shippingChange,
    onError: SolidusPaypalCommercePlatform.handleError
  }).render('#paypal-button-container')
}

SolidusPaypalCommercePlatform.renderCartButton = function(payment_method_id, style) {
  paypal.Buttons({
    style: style,
    createOrder: SolidusPaypalCommercePlatform.sendOrder.bind(null, payment_method_id),
    onClick: (data) => { SolidusPaypalCommercePlatform.fundingSource = data.fundingSource },
    onApprove: SolidusPaypalCommercePlatform.finalizeOrder.bind(null, payment_method_id),
    onShippingChange: SolidusPaypalCommercePlatform.shippingChange,
    onError: SolidusPaypalCommercePlatform.handleError
  }).render('#paypal-button-container')
}

SolidusPaypalCommercePlatform.renderProductButton = function(payment_method_id, style) {
  paypal.Buttons({
    style: style,
    createOrder: SolidusPaypalCommercePlatform.createAndSendOrder.bind(null, payment_method_id),
    onClick: (data) => { SolidusPaypalCommercePlatform.fundingSource = data.fundingSource },
    onApprove: SolidusPaypalCommercePlatform.finalizeOrder.bind(null, payment_method_id),
    onShippingChange: SolidusPaypalCommercePlatform.shippingChange,
    onError: SolidusPaypalCommercePlatform.handleError
  }).render('#paypal-button-container')
}

SolidusPaypalCommercePlatform.renderVenmoStandalone = function(payment_method_id, style) {
  paypal.Buttons({
    style: style,
    fundingSource: paypal.FUNDING.VENMO,
    createOrder: SolidusPaypalCommercePlatform.sendOrder.bind(null, payment_method_id),
    onClick: () => { SolidusPaypalCommercePlatform.fundingSource = paypal.FUNDING.VENMO },
    onApprove: SolidusPaypalCommercePlatform.approveOrder,
    onError: SolidusPaypalCommercePlatform.handleError
  }).render('#paypal-button-container')
}
