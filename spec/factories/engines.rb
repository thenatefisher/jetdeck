# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :engine do
    serial "MyString"
    label "MyString"
    totalTime 1
    totalCycles 1
    year 1
    smoh 1
    type ""
    hsi 1
    shsi 1
    model_id 1
    baseline false
    baseline_id 1
  end
end
