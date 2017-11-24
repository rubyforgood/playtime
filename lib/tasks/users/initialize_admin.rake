# frozen_string_literal: true

require 'admin_initializer'

namespace :users do
  desc 'Initialize the ENV-specified admin account'
  task initialize_admin: :environment do
    AdminInitializer.new.promote_or_create_admin
  end
end
