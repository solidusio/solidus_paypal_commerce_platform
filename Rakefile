# frozen_string_literal: true

require 'solidus_dev_support/rake_tasks'

# Take note that `SolidusDevSupport::RakeTasks.install` automatically invokes
# the `extension:test_app` rake task (see the `install_test_app_task` method).
# Eventually, `extension:test_app` calls the
# `Solidus::InstallGenerator#setup_assets` method. We need to load
# `Spree::Frontend` and `Spree::Backend` in order to tell `setup_assets` to
# install the corresponding assets of these two Solidus components.
require 'spree/frontend'
require 'spree/backend'
SolidusDevSupport::RakeTasks.install

task default: 'extension:specs'
