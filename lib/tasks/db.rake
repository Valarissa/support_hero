namespace :db do
  task :populate => [:environment] do
    ScheduleCreator.reset_to_defaults
  end
end

