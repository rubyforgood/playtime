class WishlistsController < ApplicationController
  before_action :set_wishlist, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin, except: [:index, :show]
  helper_method :get_site_managers

  def index
    @wishlists = Wishlist.all
  end

  def show
    @site_managers = @wishlist.users
    @wishlist_items = @wishlist.wishlist_items
  end

  def new
    @wishlist = Wishlist.new
    @site_managers = User.where(site_manager: true)
  end

  def edit
    @site_managers = User.where(site_manager: true)
  end

  def create
    @wishlist = Wishlist.new(wishlist_params)

    if @wishlist.save
      create_site_managers
      redirect_to @wishlist, notice: 'Wishlist was successfully created.'
    else
      render :new
    end
  end

  def update
    update_site_managers
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

    def create_site_managers
      site_managers = params['wishlist']['site_manager']
      return unless site_managers

      site_managers.each do |user_id, value|
        @wishlist.site_managers.create(user_id: user_id.to_i) if value == '1'
      end
    end

    def update_site_managers
      @wishlist.site_managers = []
      create_site_managers
    end

    def get_site_managers(wishlist)
      users = Array.new
      wishlist.site_managers.each do |manager|
        users.push(@users.find(manager.user_id).name)
      end
      return users.to_sentence
    end
end
