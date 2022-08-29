# frozen_string_literal: true

FactoryBot.define do
  factory :shopper do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    nif { SecureRandom.hex }
  end
end
