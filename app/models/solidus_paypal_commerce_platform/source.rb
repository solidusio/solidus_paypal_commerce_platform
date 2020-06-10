module SolidusPaypalCommercePlatform
  class Source < SolidusSupport.payment_source_parent_class
    self.table_name = "paypal_commerce_platform_sources"
    validates_presence_of :paypal_order_id, :payment_method_id

    def actions
      %w(capture void credit)
    end

    def can_capture?(payment)
      payment.pending? || payment.checkout?
    end

    def can_void?(payment)
      can_capture?(payment)
    end

    def can_credit?(payment)
      payment.completed? && 
      payment.credit_allowed > 0 && 
      capture_id && 
      request.get_order(paypal_order_id).status == "COMPLETED"
    end

    private

    def request
      SolidusPaypalCommercePlatform::Requests.new(payment_method.client_id, payment_method.client_secret)
    end

  end
end
