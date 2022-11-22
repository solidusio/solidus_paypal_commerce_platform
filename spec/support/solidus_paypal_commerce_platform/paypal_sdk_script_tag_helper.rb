module PaypalSdkScriptTagHelper
  def js_sdk_script_query
    URI(page.find('script[src*="sdk/js?"]', visible: false)[:src]).query.split('&')
  end

  def js_sdk_script_partner_id
    page.find('script[src*="sdk/js?"]', visible: false)['data-partner-attribution-id']
  end
end

RSpec.configure do |config|
  config.include PaypalSdkScriptTagHelper, type: :system
end
