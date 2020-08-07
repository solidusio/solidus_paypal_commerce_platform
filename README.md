# SolidusPaypalCommercePlatform

[![CircleCI](https://circleci.com/gh/nebulab/solidus_paypal_commerce_platform.svg?style=shield)](https://circleci.com/gh/nebulab/solidus_paypal_commerce_platform)
[![codecov](https://codecov.io/gh/nebulab/solidus_paypal_commerce_platform/branch/master/graph/badge.svg)](https://codecov.io/gh/nebulab/solidus_paypal_commerce_platform)

The official PayPal integration of Solidus.

## Installation

Add solidus_paypal_commerce_platform to your Gemfile:

```ruby
gem 'solidus_paypal_commerce_platform'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g solidus_paypal_commerce_platform:install
```

### PayPal Sandbox/Live Environment

This extension will automatically select a PayPal environment based on Rails environment so that "production" will be mapped to the "live" PayPal environment, and everything else will be routed to the "sandbox" PayPal environment.

If you want to override these values you can either set `SolidusPaypalCommercePlatform.config.env` to `"live"` or `"sandbox"` inside an initializer. Or, alternatively, you can set the `PAYPAL_ENV` environment variable to one of the same two values.

### Custom PartnerID, PartnerClientID, and Nonce

You can declare your PayPal Partner-ID and Partner-Client-ID as environment
variables or set their values directly on `SolidusPaypalCommercePlatform.config`
or by using the configuration method detailed in the Customization section.

#### Use ENV variables

```shell
export PAYPAL_NONCE="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxbdb84"
export PAYPAL_PARTNER_ID="xxxxxxxxxxKG2"
export PAYPAL_PARTNER_CLIENT_ID="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxVSX"
```

#### Set them directly

```ruby
SolidusPaypalCommercePlatform.config.nonce = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxbdb84"
SolidusPaypalCommercePlatform.config.partner_id = "xxxxxxxxxxKG2"
SolidusPaypalCommercePlatform.config.partner_client_id = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-xxxxxxxxxxxxxxxxxxxxxxxxxVSX"
```

## Address Phone Number Validation

Since PayPal is being used as the checkout if the user checks out on the product or cart page, and PayPal doesn't collect phone numbers, this extension disables phone number required validation for `Spree::Address`. To turn phone number validation back on, you'll need to either:

A) Turn off cart and product page checkout - configurable on the admin payment method page for PayPal Commerce Platform.
-OR-
B) Collect the users phone number seperately

and then override the `Spree::Address` method `require_phone?` to return `true`.

## Usage

### I already have API credentials

If you already have API credentials, then you'll need to store them somewhere. You can do this directly in the
preferences of the payment method, but we recommend storing your API credentials as an ENV variable and loading
them in as a preference on initialization.

```ruby
# config/initializers/spree.rb
Spree::Config.configure do |config|
  config.static_model_preferences.add(
    SolidusPaypalCommercePlatform::PaymentMethod,
    'paypal_commerce_platform_credentials', {
      test_mode: !Rails.env.production?,
      client_id: ENV['PAYPAL_CLIENT_ID'],
      client_secret: ENV['PAYPAL_CLIENT_SECRET'],
      paypal_email_confirmed: true,
      display_on_product_page: true,
      display_on_cart: true,
    }
  )
end
```

### I don't have API credentials

In this case, we still recommend following the above flow for security, but we have made a payment method setup
wizard to make it easier to get started. On the payment_methods index page, you'll see a button to set up your
PayPal Commerce Platform payment method. Click on this button and follow the instructions provided by PayPal.
When you return to your app, your payment method should be set up and ready to go.

### Email Confirmation

A confirmed email is required to get paid by PayPal. You'll need to check `Paypal Email Confirmed` on your new
payment method before being able to select `Available To Users`.

## Wizards

This gem adds support for payment method wizards to be set up. Payment wizards can be used to automatically set up
payment methods by directing the user to a sign-in page for whatever service they're connecting. In this gem, the
user is directed to sign up/in for PayPal, and then give their app access to their credentials, which is store in
preferences.

To add a payment wizard, add the class where your wizard is stored on initialization:

```ruby
initializer "register_solidus_paypal_commerce_platform_wizard", after: "spree.register.payment_methods" do |app|
  app.config.spree.payment_setup_wizards << "SolidusPaypalCommercePlatform::Wizard"
end
```

The instances of your wizard class should respond to `#name` and `#partial_name`, where `partial_name` will return the path to the partial you'd like to display on the wizard setup section. In our case, we just display a button to direct the user to PayPal.

## Custom Checkout Steps

With product and cart page checkout, the user is directed to the checkout confirmation step when they return from PayPal. If you've removed the confirmation step, you'll need to override the `SolidusPaypalCommercePlatform.finalizeOrder` JavaScript method to instead complete the order.

## Backend Payments

PayPals API does not allow for admin-side payments. Instead, backend users taking payments for customers will need to use the PayPal Virtual Terminal to take payments. [More info is available on the PayPal website.](https://www.paypal.com/merchantapps/appcenter/acceptpayments/virtualterminal?locale.x=en_US)

## Development

### Testing the extension

First bundle your dependencies, then run `bin/rake`. `bin/rake` will default to building the dummy
app if it does not exist, then it will run specs. The dummy app can be regenerated by using
`bin/rake extension:test_app`.

```shell
bundle
bin/rake
```

To run [Rubocop](https://github.com/bbatsov/rubocop) static code analysis run

```shell
bundle exec rubocop
```

When testing your application's integration with this extension you may use its factories.
Simply add this require statement to your spec_helper:

```ruby
require 'solidus_paypal_commerce_platform/factories'
```

### Running the sandbox

To run this extension in a sandboxed Solidus application, you can run `bin/sandbox`. The path for
the sandbox app is `./sandbox` and `bin/rails` will forward any Rails commands to
`sandbox/bin/rails`.

Here's an example:

```shell
$ bin/rails server
=> Booting Puma
=> Rails 6.0.2.1 application starting in development
* Listening on tcp://127.0.0.1:3000
Use Ctrl-C to stop
```

### Releasing new versions

Your new extension version can be released using `gem-release` like this:

```shell
bundle exec gem bump -v VERSION --tag --push --remote upstream && gem release
```

## License

Copyright (c) 2020 Nebulab srls, released under the New BSD License
