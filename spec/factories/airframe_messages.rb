FactoryGirl.define do
  factory :airframe_message do
    association :airframe, factory: :airframe
    association :creator, factory: :user
    association :recipient, factory: :contact
    association :airframe_spec, factory: :airframe_spec
    subject "Airframe Message Subject"
  end
end
