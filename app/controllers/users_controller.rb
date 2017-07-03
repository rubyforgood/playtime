class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html { @users = User.all }
      format.csv  { export_csv }
    end
  end

  def show
  end

  def edit
  end

  def update
    if wishlist_ids = params[:user][:wishlist_ids]
      @user.wishlist_ids = wishlist_ids
    end

    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :admin, :site_manager)
    end

    def wishlists_from_params
      wishlist_ids = params[:user][:wishlist_ids].map(&:to_i)
      wishlists = Wishlist.where(id: wishlist_ids)
    end

    def export_csv
      send_data(User.generate_csv, filename: "user_data#{Time.now.to_i}.csv")
    end
end
