class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method [:current_user=, :current_user, :logged_in?, :admin?, :site_manager?]
  before_action :get_wishlists, :get_items, :get_users

  private

  def current_user=(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logout
    reset_session
    redirect_to '/'
  end

  def logged_in?
    !current_user.nil?
  end

  def admin?
    current_user.try(:admin?)
  end

  def site_manager?
    current_user.try(:site_managers.try(:any?))
  end

  def authenticate_admin
    redirect_to root_url unless admin?
  end

  def get_wishlists
    @all_wishlists = Wishlist.all
  end

  def get_items
    @items = Item.all
  end

  def get_users
    @users = User.all
  end
end
