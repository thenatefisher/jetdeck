FactoryGirl.define do
  # dd if=/dev/zero of=somefile.jpg bs=10485760 count=1
  # truncate -s 5M somefile.jpg
  # fallocate -l 5G somefile.jpg

  factory :airframe_image do
    creator {FactoryGirl.create(:user)}
    association :airframe, factory: :airframe
    image File.new("spec/fixtures/favicon.png")
  end
end
