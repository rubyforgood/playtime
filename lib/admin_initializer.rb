# frozen_string_literal: true

##
# Initializes an admin user from ENV
#
# The purpose of this class is to isolate the behavior required by the
# `rake users:initialize_admin` task for easier testing and code maintainability.
# For testing purposes, ENV and Rails.logger can be overridden by keyword
# arguments when the class is instantiated.
class AdminInitializer
  attr_reader :env

  def initialize(env: ENV, out: STDOUT)
    unless env['ADMIN_AMAZON_EMAIL'] && env['ADMIN_NAME']
      raise 'Please set the ADMIN_NAME and ADMIN_AMAZON_EMAIL ' \
            'environment variables'
    end

    @env = env
    @email = env['ADMIN_AMAZON_EMAIL']
    @name = env['ADMIN_NAME']
    @out = out
  end

  def promote_or_create_admin
    if (you = User.find_by(email: email))
      you.update!(admin: true)
      out.puts "Promoted #{you.display_name} to admin"
    else
      User.new(name: name, email: email, admin: true).save!
      out.puts "Created new admin user: #{name} <#{email}>"
    end
  end

  private

  attr_reader :email, :name, :out
end
