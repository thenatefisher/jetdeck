FactoryGirl.define do

    factory :user do
        password "secret"
        password_confirmation "secret"
        association :contact, factory: :contact, first: "TEST", last: "NAME"
    end

end

