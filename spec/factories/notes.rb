FactoryGirl.define do
  factory :airframe_note, parent: :note do
    association :author, factory: :user
    association :notable, factory: :airframe
    body "An airframe note"
  end
  factory :contact_note, parent: :note do
    association :author, factory: :user
    association :notable, factory: :contact
    body "A contact note"
  end  
end
