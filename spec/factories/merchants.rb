# frozen_string_literal: true

FactoryBot.define do
  factory :merchant do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    cif { SecureRandom.hex }

    trait :with_orders do
      after(:create) do |merchant|
        create_list :order, 5, :completed, merchant:
      end
    end
  end
end
