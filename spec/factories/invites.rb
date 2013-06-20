FactoryGirl.define do

	domains = %w[gmail aol msn att yahoo hotmail]

	sequence :email, domains.cycle do |d|
	    "test@#{d}.com"
	end

	factory :invite do
		association :sender, factory: :user
		email {generate(:email)}
	end

end
