# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ryte_admin, :class => 'Ryte::Admin' do
    email                 'test@example.org'
    password              'password'
    password_confirmation 'password'
  end
end
