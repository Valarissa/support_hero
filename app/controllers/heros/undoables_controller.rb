module Heros
  class UndoablesController < ApplicationController
    def create
      @hero = Hero.find(params[:id])
      day = Day.find(params[:day_id])
      @hero.undoables.create(date: day.date)
      redirect_to hero_path(@hero)
    end
  end
end
