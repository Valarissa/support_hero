class ScheduleController < ApplicationController
  def index
    if params[:year].present? && params[:month].present?
      date = Date.new(params[:year].to_i, params[:month].to_i)
    else
      date = Date.today
    end
    @next = date + 1.month
    @prev = date - 1.month
    @days = Day.where(date: date.beginning_of_month..date.end_of_month)
               .where.not(hero_id: nil)
  end
end
