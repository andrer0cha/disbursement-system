# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    association :merchant
    association :shoper
    amount  { rand.round(2) }
    completed_at { Date.today-((0..10).rand.days) }
    cif { SecureRandom.hex }
  end
end