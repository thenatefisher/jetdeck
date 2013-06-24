FactoryGirl.define do
  factory :lead do
    association :airframe, factory: :airframe
    association :contact, factory: :contact
    association :creator, factory: :user
  end
end
