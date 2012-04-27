# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :equipment_detail do
    equipment_id 1
    value "MyString"
    parameter "MyString"
  end
end
