FactoryGirl.define do

  factory :contact do
    email {Faker::Internet.email}
    email_confirmation { email }
  end

  factory :contact_with_data, parent: :contact  do
    first {Faker::Name.first_name}
    last {Faker::Name.last_name}
    company {Faker::Company.name}
    phone {Faker::PhoneNumber.phone_number}
  end

end
