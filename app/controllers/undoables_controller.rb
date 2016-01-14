class UndoablesController < ApplicationController
  def index
    @hero = Hero.find(params[:hero_id])
    @undoable_days = @hero.undoable_days
  end

  def create
    hero = Hero.find(params[:hero_id])
    day = Day.find(params[:day_id])
    hero.undoable(day)
    redirect_to hero_path(hero)
  end

  def destroy
    hero = Hero.find(params[:hero_id])
    undoable_day = UndoableDay.find(params[:id])
    day = Day.find_by(date: undoable_day.date)
    undoable_day.destroy
    day.update_attribute(:hero_id, hero.id)
    redirect_to hero_path(hero)
  end
end
