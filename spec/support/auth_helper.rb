module AuthHelper
  def http_login_if_needed
    return if ENV['BASIC_AUTH'].blank?

    name, password = ENV['BASIC_AUTH'].split(':')
    page.driver.browser.authorize(name, password)
  end

  def http_login_if_needed_js
    return if ENV['BASIC_AUTH'].blank?

    name, password = ENV['BASIC_AUTH'].split(':')
    page.driver.basic_authorize(name, password)
  end

  def basic_auth_header
    return {} if ENV['BASIC_AUTH'].blank?

    name, password = ENV['BASIC_AUTH'].split(':')
    { 'HTTP_AUTHORIZATION' => ActionController::HttpAuthentication::Basic.encode_credentials(name, password) }
  end
end
