FactoryBot.define do
  factory :instrument do
    ticker { Faker::Alphanumeric.alphanumeric(number: 4) }
    name { Faker::Company.industry }

    exchange { FactoryBot.create(:exchange) }
  end
end

