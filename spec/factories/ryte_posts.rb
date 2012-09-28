# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ryte_post, :class => 'Ryte::Post' do
    title "Hello World"
    body "This is the body of a Ryte Post"
    status "draft"
  end
end
