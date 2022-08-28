# frozen_string_literal: true

FactoryBot.define do
  factory :shopper do
    sequence :email do |n|
      email { "mike#{n}@shoper.com" }
    end
    sequence :name do |n|
      name { "Mike #{n}" }
    end
    cif { SecureRandom.hex }
  end
end