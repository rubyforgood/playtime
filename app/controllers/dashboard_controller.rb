class DashboardController < ApplicationController
  def show
    @pledges = current_user.pledges
  end
end
