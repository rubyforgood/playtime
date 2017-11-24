# frozen_string_literal: true

class PledgesController < ApplicationController
  before_action :set_pledge, only: %i[show edit update destroy]

  def index
    authorize Pledge
    respond_to do |format|
      format.csv  { export_csv }
      format.html do
        @pledges = Pledge.includes(:user, wishlist_item: %i[item wishlist])
      end
    end
  end

  def show
    authorize @pledge
  end

  def edit
    authorize @pledge
  end

  def create
    authorize Pledge
    @pledge = Pledge.increment_or_new(pledge_create_params)

    if @pledge.save
      redirect_to @pledge, notice: 'Pledge was successfully created.'
    else
      message = "Invalid pledge: #{@pledge.errors.full_messages.join('; ')}"
      redirect_to :root, alert: message
    end
  end

  def update
    authorize @pledge
    if @pledge.update(pledge_update_params)
      redirect_to @pledge, notice: 'Pledge was successfully updated.'
    else
      render :edit
    end
  end

  def claim
    @pledge = Pledge.find(params[:pledge_id])
    authorize @pledge

    if @pledge.claim_or_increment(user_id: current_user.id)
      redirect_to @pledge, notice: 'You have claimed this pledge.'
    else
      render :edit
    end
  end

  def destroy
    authorize @pledge
    redirect_path = @pledge.anonymous? ? root_path : user_path(@pledge.user)
    @pledge.destroy

    redirect_to redirect_path, notice: 'Pledge was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pledge
    @pledge = Pledge.find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def pledge_create_params
    params.require(:pledge).permit(:wishlist_item_id, :user_id)
  end

  def pledge_update_params
    params.require(:pledge).permit(:quantity)
  end

  def export_csv
    send_data(Pledge.generate_csv, filename: "pledge_data#{Time.now.to_i}.csv")
  end
end
