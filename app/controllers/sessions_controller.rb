class SessionsController < ApplicationController
  before_action :skip_authorization

  def new
    if current_user.logged_in?
      redirect_to '/'
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
end
