# frozen_string_literal: true

module SolidusPaypalCommercePlatform
  class WebhookJob < SolidusPaypalCommercePlatform::ApplicationJob
    def perform(payload)
      case payload["resource_type"]
      when "checkout-order"
        payment_source = PaymentSource.find_by!(paypal_order_id: payload.dig("resource", "id"))
        payment = ::Spree::Payment.where(source: payment_source).last!
        payment.log_entries.create!(details: payload.to_yaml)
      when "capture"
        payment_source = PaymentSource.find_by!(capture_id: payload.dig("resource", "id"))
        payment = ::Spree::Payment.where(source: payment_source).last!
        payment.log_entries.create!(details: payload.to_yaml)
      when "refund"
        payment_source = PaymentSource.find_by!(refund_id: payload.dig("resource", "id"))
        payment = ::Spree::Payment.where(source: payment_source).last!
        payment.log_entries.create!(details: payload.to_yaml)
      end
    end
  end
end
