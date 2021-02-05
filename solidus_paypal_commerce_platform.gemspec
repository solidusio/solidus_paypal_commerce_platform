# frozen_string_literal: true

require_relative 'lib/solidus_paypal_commerce_platform/version'

Gem::Specification.new do |spec|
  spec.name = 'solidus_paypal_commerce_platform'
  spec.version = SolidusPaypalCommercePlatform::VERSION
  spec.authors = ['Sean Denny', 'Elia Schito']
  spec.email = 'contact@solidus.io'

  spec.summary = 'Integrate Solidus with Paypal Commerce Platform'
  spec.homepage = 'https://github.com/solidusio-contrib/solidus_paypal_commerce_platform'
  spec.license = 'BSD-3-Clause'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/solidusio-contrib/solidus_paypal_commerce_platform'
  spec.metadata['changelog_uri'] = 'https://github.com/solidusio-contrib/solidus_paypal_commerce_platform/releases'

  spec.required_ruby_version = Gem::Requirement.new('~> 2.5')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }

  spec.files = files.grep_v(%r{^(test|spec|features)/})
  spec.test_files = files.grep(%r{^(test|spec|features)/})
  spec.bindir = "exe"
  spec.executables = files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'deface', '~> 1.5'
  spec.add_dependency 'solidus_core', ['>= 2.0.0', '< 3']
  spec.add_dependency 'solidus_support', [">= 0.8.0", "< 1"]
  spec.add_dependency 'solidus_webhooks', '~> 0.2'

  spec.add_dependency 'paypal-checkout-sdk'

  spec.add_development_dependency 'cuprite'
  spec.add_development_dependency 'solidus_dev_support', '~> 2.1'
end
