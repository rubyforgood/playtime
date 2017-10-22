class WishlistsController < ApplicationController
  before_action :set_wishlist, only: [:edit, :update, :destroy]

  def show
    skip_authorization
    @wishlist = Wishlist.includes(wishlist_items: :item).find(params[:id])
    @site_managers = @wishlist.users
    @wishlist_items = @wishlist.wishlist_items.priority_order
  end

  def new
    authorize Wishlist
    @wishlist = Wishlist.new
    @admins = User.admin
  end

  def edit
    authorize @wishlist
    @admins = User.admin
  end

  def create
    authorize Wishlist
    @wishlist = Wishlist.new(wishlist_params)
    attach_site_managers

    if @wishlist.save
      redirect_to @wishlist, notice: 'Wishlist was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize @wishlist
    attach_site_managers
    if @wishlist.update(wishlist_params)
      redirect_to @wishlist, notice: 'Wishlist was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @wishlist
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
