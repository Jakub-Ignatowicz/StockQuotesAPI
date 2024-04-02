FactoryBot.define do
  factory :quote do
    time { Faker::Time.between(from: 2.days.ago, to: Time.now) }
    open { Faker::Number.between(from: 1, to: 1000) }
    close { Faker::Number.between(from: 1, to: 1000) }
    high { Faker::Number.between(from: 1, to: 1000) }
    low { Faker::Number.between(from: 1, to: 1000) }
    volume { Faker::Number.between(from: 1, to: 1000) }

    instrument { FactoryBot.create(:instrument) }
  end
end

