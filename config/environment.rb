# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Ryte::Application.initialize!

# Setup asset paths based on current_theme.  Setup is handled
# in spec_helper.rb for testing env.
if Settings.by_name('system_setup') && !Rails.env.test?
  Ryte::Theme::Precompiler.clean_paths
  Ryte::Theme::Precompiler.append_paths
end
