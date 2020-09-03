require "capybara/cuprite"

Capybara.javascript_driver = :cuprite

Capybara.register_driver(:cuprite) do |app|
  # Set `export INSPECTOR=true` and add `page.driver.debug(binding)` to open a Chrome tab
  # to debug the browser status.
  #
  # See also: https://github.com/rubycdp/cuprite#debugging
  Capybara::Cuprite::Driver.new(app, window_size: [1920, 1080], inspector: ENV["INSPECTOR"])
end
