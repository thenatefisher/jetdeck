FactoryGirl.define do
  factory :airframe_spec do
    image File.new("spec/support/f1040.pdf")
    association :airframe, factory: :airframe
    association :creator, factory: :User
  end
end
