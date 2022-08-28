# frozen_string_literal: true

FactoryBot.define do
  factory :merchant do
    sequence :email do |n|
      email { "john#{n}@merchant.com" }
    end
    sequence :name do |n|
      name { "John #{n}" }
    end
    cif { SecureRandom.hex }
  end
end
