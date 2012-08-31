class Ryte::Setting
  include Mongoid::Document

  ALLOWED_TYPES = %w(system theme)

  embedded_in :setting_list, class_name: "Ryte::Setting::List"

  field :name,  type: String, default: ""
  field :value
  field :display, type: String, default: ""
  field :bundle, type: String, default: ""
  field :type, type: String, default: ""

  validates :name, presence: true, uniqueness: true, format: { with: /\A[a-z|\d|_]+$/ }
  validates :bundle, presence: true, format: { with: /\A[a-z|\d|_]+$/ }
  validates :type, presence: true, inclusion: { in: ALLOWED_TYPES }

  ALLOWED_TYPES.each do |expected|
    define_method "#{expected}?" do
      self.type == expected
    end
  end
end
