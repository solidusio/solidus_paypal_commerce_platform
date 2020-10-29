module SolidusPaypalCommercePlatform
  class AddRackAuthBasic < Rails::Railtie
    initializer "basic_auth.enable_rack_middleware" do |app|
      if ENV['BASIC_AUTH'].present?
        app.middleware.use ::Rack::Auth::Basic do |u, p|
          [u, p] == ENV['BASIC_AUTH'].split(':')
        end
      end
    end
  end
end
