# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  helper_method :current_user
  before_action :set_wishlists # required for the nav menu

  after_action :verify_authorized
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def current_user
    return @current_user if @current_user
    @current_user = User.find_by(id: session[:user_id]) || GuestUser.new
  end

  def set_wishlists
    @wishlists = Wishlist.all
  end

  def user_not_authorized
    redirect_to root_url, alert: 'You are not authorized to view that page.'
  end
end
