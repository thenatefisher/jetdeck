FactoryGirl.define do
  # dd if=/dev/zero of=somefile.pdf bs=10485760 count=1
  # truncate -s 10M somefile.pdf
  # fallocate -l 10G somefile.pdf

  factory :airframe_spec do
    spec File.new("spec/fixtures/f1040.pdf")
    association :airframe, factory: :airframe
    association :creator, factory: :user
  end
end
