class PledgesController < ApplicationController
  before_action :set_pledge, only: [:show, :edit, :update, :destroy]

  def index
    @pledges = Pledge.all
  end

  def show
  end

  def new
    @pledge = Pledge.new
  end

  def edit
  end

  def create
    @pledge = Pledge.new(pledge_params)

    if @pledge.save
      redirect_to @pledge, notice: 'Pledge was successfully created.'
    else
      render :new
    end
  end

  def update
    if @pledge.update(pledge_params)
      redirect_to @pledge, notice: 'Pledge was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @pledge.destroy
    redirect_to pledges_url, notice: 'Pledge was successfully destroyed.'
  end

  def export_csv
    send_data(Pledge.generate_csv, filename: "pledge_data#{Time.now.to_i}.csv")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pledge
      @pledge = Pledge.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pledge_params
      params.require(:pledge).permit(:item_id, :user_id)
    end
end
