# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :setting, :class => 'Ryte::Setting' do
    sequence(:name) {|n| "test_name_#{n}" }
    bundle "twitter"
    type "theme"
  end
end
