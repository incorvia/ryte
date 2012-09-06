def setup_current_theme
  Settings.load([Ryte::Setting.new(
    name: "current_theme",
    value: "default",
    display: "Default",
    bundle: "system",
    type: "system")])
end

def clear_settings
  settings = Settings.all
  settings.each { |x| x.destroy }
end
