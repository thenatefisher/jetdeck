# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :note do
    title "MyString"
    description "MyText"
    created_by 1
    notable_type "MyString"
    notable_id 1
  end
end
