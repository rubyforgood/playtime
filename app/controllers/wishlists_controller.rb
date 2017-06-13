class WishlistsController < ApplicationController
  before_action :set_wishlist, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin, except: [:index, :show]
  helper_method :get_site_managers

  # GET /wishlists
  # GET /wishlists.json
  def index
    @wishlists = Wishlist.all
  end

  # GET /wishlists/1
  # GET /wishlists/1.json
  def show
    @site_managers = @wishlist.users
    @wishlist_items = @wishlist.wishlist_items
  end

  # GET /wishlists/new
  def new
    @wishlist = Wishlist.new
    @site_managers = User.where(site_manager: true)
  end

  # GET /wishlists/1/edit
  def edit
    @site_managers = User.where(site_manager: true)
  end

  # POST /wishlists
  # POST /wishlists.json
  def create
    @wishlist = Wishlist.new(wishlist_params)

    respond_to do |format|
      if @wishlist.save
        create_site_managers
        format.html { redirect_to @wishlist, notice: 'Wishlist was successfully created.' }
        format.json { render :show, status: :created, location: @wishlist }
      else
        format.html { render :new }
        format.json { render json: @wishlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wishlists/1
  # PATCH/PUT /wishlists/1.json
  def update
    respond_to do |format|
      update_site_managers
      if @wishlist.update(wishlist_params)
        format.html { redirect_to @wishlist, notice: 'Wishlist was successfully updated.' }
        format.json { render :show, status: :ok, location: @wishlist }
      else
        format.html { render :edit }
        format.json { render json: @wishlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wishlists/1
  # DELETE /wishlists/1.json
  def destroy
    @wishlist.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Wishlist was successfully destroyed.' }
      format.json { head :no_content }
    end
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
