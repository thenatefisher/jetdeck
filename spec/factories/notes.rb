FactoryGirl.define do

  factory :note do
  end

  factory :airframe_note, parent: :note do
    association :author, factory: :user
    association :notable, factory: :airframe
    description "An airframe note"
  end
  factory :contact_note, parent: :note do
    association :author, factory: :user
    association :notable, factory: :contact
    description "A contact note"
  end  
end
