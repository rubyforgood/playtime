class SessionsController < ApplicationController
  skip_before_action :authenticate_admin

  def new
    if logged_in?
      redirect_to '/'
    else
      redirect_to '/auth/amazon'
    end
  end

  def destroy
    logout
  end

  def create
    @user = User.find_or_create_from_amazon_hash!(auth_hash)
    self.current_user = @user

    redirect_to '/'
  end

  def failure
    msg = "Authentication error: #{params[:message].humanize}"

    Rails.logger.info(msg)
    redirect_to root_url, alert: msg
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
