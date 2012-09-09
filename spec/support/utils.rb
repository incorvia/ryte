#---------- SpecHelper Utilities ----------

def pre_flight
  Mongoid.purge!
  Ryte::Setup.setup!(approve: false, feedback: false)
  Ryte::Setting::List.instance_variable_set(:@_list, nil)
end

def post_flight
  Ryte::Setting::List.instance_variable_set(:@_list, nil)
end

#----------- Settings Utilities -----------

def setup_current_theme
  Settings.load([Ryte::Setting.new(
    name: "current_theme",
    value: "default",
    display: "Default",
    bundle: "system",
    type: "system")])
end

def clear_settings
  Settings.all.delete_all
end
