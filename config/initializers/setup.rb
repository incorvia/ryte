# Setup system if system has not been previously setup.  Setup is handled
# in spec_helper.rb for testing env.
unless Settings.by_name('system_setup') || Rails.env.test?
  Ryte::Setup.setup!
end
