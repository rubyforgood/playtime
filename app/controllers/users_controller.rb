# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    authorize User
    respond_to do |format|
      format.html { @users = User.all }
      format.csv  { export_csv }
    end
  end

  def show
    @user = User.includes(pledges: [wishlist_item: %i[item wishlist]])
                .find(params[:id])
    authorize @user
  end

  def edit
    authorize @user
  end

  def update
    authorize @user

    # if the user's an admin, let them assign site managers
    if current_user.admin? && (wishlist_ids = params[:user][:wishlist_ids])
      @user.wishlist_ids = wishlist_ids
    end

    if @user.update(permitted_attributes(@user))
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @user
    prevent_admin_delete && return if @user.admin? && User.admin.count < 2
    @user.destroy
    if current_user == @user
      reset_session
      redirect_to root_url, notice: 'You have successfully deleted your '\
      'account.'
    else
      redirect_to users_url, notice: 'User was successfully destroyed.'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def wishlists_from_params
    wishlist_ids = params[:user][:wishlist_ids].map(&:to_i)
    Wishlist.where(id: wishlist_ids)
  end

  def export_csv
    send_data(User.generate_csv, filename: "user_data#{Time.now.to_i}.csv")
  end

  def prevent_admin_delete
    redirect_to users_url, notice: 'This account is the only remaining Admin \
    user. Please assign another Admin before deleting this account'
  end
end
