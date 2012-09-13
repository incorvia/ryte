# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ryte_post, :class => 'Ryte::Post' do
    body "This is the body of a Ryte Post"
  end
end
