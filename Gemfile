# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

branch = ENV.fetch('SOLIDUS_BRANCH', 'master')
solidus_git, solidus_frontend_git = if (branch == 'master') || (branch >= 'v3.2')
                                      %w[solidusio/solidus solidusio/solidus_frontend]
                                    else
                                      %w[solidusio/solidus] * 2
                                    end
gem 'solidus', github: solidus_git, branch: branch
gem 'solidus_frontend', github: solidus_frontend_git, branch: branch

# Needed to help Bundler figure out how to resolve dependencies,
# otherwise it takes forever to resolve them.
# See https://github.com/bundler/bundler/issues/6677
gem 'rails', ENV.fetch('RAILS_VERSION', '>0.a')

# Provides basic authentication functionality for testing parts of your engine
gem 'solidus_auth_devise'

case ENV.fetch('DB', nil)
when 'mysql'
  gem 'mysql2'
when 'postgresql'
  gem 'pg'
else
  gem 'sqlite3'
end

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3')
  # 'net/smtp' is required by 'mail', see:
  # - https://github.com/ruby/net-protocol/issues/10
  # - https://stackoverflow.com/a/72474475
  gem 'net-smtp', require: false
end

gemspec

# Use a local Gemfile to include development dependencies that might not be
# relevant for the project or for other contributors, e.g. pry-byebug.
#
# We use `send` instead of calling `eval_gemfile` to work around an issue with
# how Dependabot parses projects: https://github.com/dependabot/dependabot-core/issues/1658.
send(:eval_gemfile, 'Gemfile-local') if File.exist? 'Gemfile-local'
