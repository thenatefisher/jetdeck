# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :airframe_text do
    airframe_id 1
    body "MyText"
    label "MyString"
  end
end
