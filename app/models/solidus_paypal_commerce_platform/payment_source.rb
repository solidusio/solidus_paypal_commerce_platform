# frozen_string_literal: true

module SolidusPaypalCommercePlatform
  class PaymentSource < SolidusSupport.payment_source_parent_class
    self.table_name = "paypal_commerce_platform_sources"
    enum paypal_funding_source: {
      applepay: 0, bancontact: 1, blik: 2, boleto: 3, card: 4, credit: 5, eps: 6, giropay: 7, ideal: 8,
      itau: 9, maxima: 10, mercadopago: 11, mybank: 12, oxxo: 13, p24: 14, paylater: 15, paypal: 16, payu: 17,
      sepa: 18, sofort: 19, trustly: 20, venmo: 21, verkkopankki: 22, wechatpay: 23, zimpler: 24
    }, _suffix: :funding
    validates :paypal_order_id, :payment_method_id, presence: true

    def display_paypal_funding_source
      I18n.t(paypal_funding_source,
        scope: 'solidus_paypal_commerce_platform.paypal_funding_sources',
        default: paypal_funding_source)
    end

    def actions
      %w(capture void credit)
    end

    def can_capture?(payment)
      (payment.pending? || payment.checkout?) &&
        payment_method.gateway.get_order(paypal_order_id).status != "PENDING"
    end

    def can_void?(payment)
      can_capture?(payment)
    end

    def can_credit?(payment)
      payment.completed? &&
      payment.credit_allowed > 0 &&
      capture_id &&
      payment_method.gateway.get_order(paypal_order_id).status == "COMPLETED"
    end
  end
end
