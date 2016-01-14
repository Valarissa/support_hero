class DaysController < ApplicationController
  def edit
    @day = Day.find(params[:id])
    @swappable_days = @day.swappable_days
  end

  def update
    day = Day.find(params[:id])
    hero = day.hero # Held onto to ensure proper hero for redirect.
    swapping_day = Day.find(params[:swap_id])
    day.swap(swapping_day)
    redirect_to hero_path(hero)
  end
end
