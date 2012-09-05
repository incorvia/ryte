# Override your default settings for the Test environment here.
# 
# Example:
#   configatron.file.storage = :local

############### Setup ##################

# Path to the user directory
Ryte::Config.user_path = File.join(Rails.root, "spec", "support", "user")
