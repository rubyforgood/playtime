# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :skip_authorization
  skip_before_action :verify_authenticity_token, if: :should_skip_csrf_check?

  def new
    if current_user.logged_in?
      redirect_to '/'
    elsif development_login_enabled?
      redirect_to '/auth/developer'
    else
      redirect_to '/auth/amazon'
    end
  end

  def destroy
    reset_session
    redirect_to '/'
  end

  def create
    user = User.find_or_create_from_amazon_hash!(auth_hash)
    session[:user_id] = user.id

    redirect_to '/'
  end

  def failure
    msg = "Authentication error: #{params[:message].humanize}"

    Rails.logger.info(msg)
    redirect_to root_url, alert: msg
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end

  def should_skip_csrf_check?
    Rails.env.development? && params[:provider] == 'developer'
  end

  def development_login_enabled?
    Rails.env.development? && ENV['FORCE_AMAZON_LOGIN'] != 'true'
  end
end
