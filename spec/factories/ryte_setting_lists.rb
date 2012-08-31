# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ryte_setting_list, class: 'Ryte::Setting::List' do
  end

  factory :list_with_settings, parent: 'ryte_setting_list' do
    settings { Array.new(2){ build(:ryte_setting) } }
  end
end
