namespace :ryte do
  desc "Setup the ryte system for initial launch."
  task :setup => :environment do
    Ryte::Setup.setup!
  end
end
