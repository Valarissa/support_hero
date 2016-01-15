class UnscheduledDaysController < ApplicationController
  def index
    nobody = NullHero.new
    @unassigned_days = nobody.days
  end

  def edit
    @day = Day.find(params[:id])
    restricted_heroes = @day.undoable_days.pluck(:hero_id)
    if restricted_heroes.present?
      @heroes = Hero.where.not(id: restricted_heroes)
    else
      @heroes = Hero.all
    end
  end

  def update
    day = Day.find(params[:id])
    day.update_attribute(:hero_id, params[:day][:hero_id])
    redirect_to unscheduled_days_path
  end
end
