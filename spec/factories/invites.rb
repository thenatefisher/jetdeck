FactoryGirl.define do

	factory :invite do
		association :sender, factory: :user
		email {Faker::Internet.email}
	end

end
