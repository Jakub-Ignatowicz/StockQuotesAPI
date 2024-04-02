FactoryBot.define do
  factory :exchange do
    mic { Faker::Alphanumeric.alphanumeric(number: 4) }
    name { Faker::Company.name }
  end
end

