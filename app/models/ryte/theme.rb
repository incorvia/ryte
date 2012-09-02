class Ryte::Theme
  include ActiveModel::Validations
  include Ryte::Theme::Registration

  REQUIRED = %w(
    settings.yml
    partials/index.html.erb
  )

  attr_accessor :name, :settings, :files

  validate :name_with_regex
  validate :files_with_required

  private

  def name_with_regex
    unless name =~ Ryte::Setting::NAME_REGEX
      errors.add(:name, "Name is invalid")
    end
    errors.count > 0 ? false : true
  end

  def files_with_required
    unless (Dir.glob(matcher(name)) - REQUIRED).empty?
      errors.add(:name, "File list is incomplete")
    end
    errors.count > 0 ? false : true
  end

  def theme_dir_path(name)
    File.join(Rails.root, "user", "themes", name)
  end

  def matcher(name)
    File.join(theme_dir_path(name), "*")
  end

  def settings_path(name)
    File.join(theme_dir_path(name), 'settings.yml')
  end
end
