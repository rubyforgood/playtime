class WishlistsController < ApplicationController
  before_action :set_wishlist, only: [:show, :edit, :update, :destroy]

  skip_before_action :authenticate_admin, except: [:new, :create]
  before_action -> { authenticate_site_manager(wishlist_id: :id) },
    only: [:edit, :update, :destroy]

  def show
    @site_managers = @wishlist.users
    @wishlist_items = @wishlist.wishlist_items
  end

  def new
    @wishlist = Wishlist.new
    @admins = User.admin
  end

  def edit
    @admins = User.admin
  end

  def create
    @wishlist = Wishlist.new(wishlist_params)
    attach_site_managers

    if @wishlist.save
      redirect_to @wishlist, notice: 'Wishlist was successfully created.'
    else
      render :new
    end
  end

  def update
    attach_site_managers
    if @wishlist.update(wishlist_params)
      redirect_to @wishlist, notice: 'Wishlist was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @wishlist.destroy
    redirect_to root_path, notice: 'Wishlist was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wishlist
      @wishlist = Wishlist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wishlist_params
      params.require(:wishlist).permit(:name)
    end

    def attach_site_managers
      return unless user_ids = params['wishlist']['user_ids']
      @wishlist.user_ids = user_ids.delete_if(&:blank?).map(&:to_i)
    end
end
