class Ryte::Theme::Matchers

  class << self
    include Rails.application.routes.url_helpers
  end

  Braai::Template.map(/({{\s*admin_path\s*}})/i) do |template, key, matches|
    "#{new_admin_session_path}"
  end
end
