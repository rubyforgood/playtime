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
      user_not_authorized unless current_user.admin?
    end

    def authenticate_site_manager(wishlist_id: :wishlist_id)
      @wishlist = @wishlist_item.try(:wishlist) ||
        Wishlist.find_by(id: params[wishlist_id])
      user_not_authorized unless current_user.can_manage?(@wishlist)
    end

    def set_wishlists
      @wishlists = Wishlist.all
    end

    def user_not_authorized
      redirect_to root_url, notice: "You are not authorized to view that page."
    end
end
