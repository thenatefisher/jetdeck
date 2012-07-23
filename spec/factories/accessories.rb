# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :accessory do
    image File.new("spec/factories/image.png")
  end
end
