class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :collect_today

  def collect_today
    @today = Day.find_or_create_by(date: Date.today)
  end
end
