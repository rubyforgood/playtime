class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to '/'
    else
      redirect_to '/auth/amazon'
    end
  end

  def destroy
    logout
#    redirect_to root_url, :notice => 'Signed out!'
  end

  def create
    @user = User.find_or_create_from_amazon_hash!(auth_hash)

    self.current_user = @user
    redirect_to '/'
  end

  def failure
    puts "Authentication error: #{params[:message].humanize}"
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
