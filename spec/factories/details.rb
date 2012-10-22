# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :detail do
    detailable_type "MyString"
    detailable_id 1
    name "MyString"
    value "MyString"
  end
end
