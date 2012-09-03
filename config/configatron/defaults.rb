Ryte::Config = configatron

# Put Ryte configuration settings needed for Rails to run
# here.  Use Settings.yml for Ryte Application specific
# settings.

# Example:
#   Ryte::Config.settings_path = Configatron::Delayed.new do
#     File.join(Rails.root, "config", "settings.yml"
#   end

############### Setup ##################

# Path to settings.yml for Ryte::Setup
Ryte::Config.settings_path = Configatron::Delayed.new do
 File.join(Rails.root, "config", "settings.yml")
end

# Path to the user directory
Ryte::Config.users_path = Configatron::Delayed.new do
 File.join(Rails.root, "user")
end
