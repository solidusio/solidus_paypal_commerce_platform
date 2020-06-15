module SolidusPaypalCommercePlatform
  class Response < ActiveMerchant::Billing::Response
    DESIRED_STATUS_CODES = [201, 204]

    def initialize(response, success_message)
      if DESIRED_STATUS_CODES.include? response.status_code
        super(true, success_message, {result: response.result})
      else
        super(false, "A problem has occurred with this payment, please try again.")
      end
    end

  end
end
