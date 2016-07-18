class HomeController < ApplicationController
  def index
    if current_user
      @dev_id       = params[:developer_id]
      @project      = params[:project]
      @start_date   = params[:start_date]
      @end_date     = params[:end_date]
      @not_finished = params[:not_finished].present?
    else
      redirect_to '/login'
    end
  end
end