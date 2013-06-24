FactoryGirl.define do

  factory :user do
    password "secret"
    password_confirmation "secret"
    association :contact, factory: :contact
  end

end
