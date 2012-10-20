# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invite do
    from_user_id 1
    to_contact_id 1
    activated false
    message "MyText"
  end
end
