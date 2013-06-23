FactoryGirl.define do

    factory :airframe do
        association :creator, factory: :user
    end

end
