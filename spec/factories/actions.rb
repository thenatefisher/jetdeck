# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :action do
    title "MyString"
    description "MyText"
    due "2012-09-25 18:29:19"
    contact_id 1
    is_complete false
  end
end
