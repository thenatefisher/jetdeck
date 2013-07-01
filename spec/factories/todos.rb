FactoryGirl.define do

  factory :todo do
  end

  factory :contact_todo, parent: :todo do
    title "Contact Todo"
    association :actionable, factory: :contact
  end
  factory :airframe_todo, parent: :todo do
    title "Airframe Todo"
    association :actionable, factory: :airframe
  end
end
