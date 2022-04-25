FactoryBot.define do
    factory :app do
      name { Faker::Lorem.word }
    end
  end