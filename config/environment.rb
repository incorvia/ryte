# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Ryte::Application.initialize!

unless $rails_rake_task
  Ryte::Theme::Precompiler.clean_paths
  Ryte::Theme::Precompiler.append_paths
end
