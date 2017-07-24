class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user
  before_action :set_wishlists # required for the nav menu

  # Require admin status by default.
  #
  # To override for a view, add:
  #
  #     `skip_before_action :authenticate_admin, only: [...]`
  #
  # to your controller
  before_action :authenticate_admin

  private
    def current_user
      return @current_user if @current_user
      @current_user = User.find_by(id: session[:user_id]) || GuestUser.new
    end

    def authenticate_admin
      redirect_to root_url unless current_user.admin?
    end

    def set_wishlists
      @wishlists = Wishlist.all
    end
end
