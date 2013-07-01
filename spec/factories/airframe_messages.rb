FactoryGirl.define do
  factory :airframe_message do
    association :airframe, factory: :airframe
    creator {FactoryGirl.build(:user, :activated => true)}
    association :recipient, factory: :contact
    association :airframe_spec, factory: :airframe_spec
    subject "Airframe Message Subject"
  end
end
