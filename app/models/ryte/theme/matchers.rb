class Ryte::Theme::Matchers

  class << self
    include Rails.application.routes.url_helpers
  end

  # Admin Path
  Braai::Template.map(/({{\s*admin_path\s*}})/i) do |template, key, matches|
    "#{new_admin_session_path}"
  end

  # Date Helper
  Braai::Template.map(/({{\s*date\((.*),(.*)\)\s*}})/) do |template, key, matches|
    time = Time.parse(matches[1])
    time.strftime(matches[2])
  end

  # Partials
  Braai::Template.map(/({{(\s*partial\s*(\w*)\s*(\|.*)?)}})/i) do |template, key, matches|
    path        = File.join(Settings.current_views_path, "_#{matches[2]}.html")
    partial     = "#{File.open(path).read}"
    attributes  = {}

    unless matches[3].blank?
      attr_set    = matches[3][1..-1].strip.split(',') if matches[3]

      attr_set.each do |hash|
        kv_array  = hash.split(":")
        new_key   = kv_array[0].strip
        new_val   = kv_array[1].strip
        new_value = template.attributes[new_val] ||= new_val

        attributes[new_key] = new_value
      end
    end

    Braai::Template.new(partial).render(attributes)
  end

  # Variable Eval
  Braai::Template.map(/({{\s*([\w]+)\.([\w]+)\s*}})/i) do |template, key, matches|
    attr = template.attributes[matches[1]]
    attr ? attr.send(matches[2]) : nil
  end
end
