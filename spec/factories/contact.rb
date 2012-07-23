FactoryGirl.define do

    domains = %w[gmail aol msn att yahoo hotmail]

    sequence :email, domains.cycle do |d|
        "test@#{d}.com"
    end

    factory :contact do
        email { generate(:email) }
        email_confirmation { email }
    end

    factory :contact_with_data, parent: :contact  do
        first "FIRST"
        last "LAST"
        company "COMPANY"
        phone "(333) 444-2222"
    end

end
