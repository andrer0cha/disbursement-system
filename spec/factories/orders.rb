# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    association :merchant
    association :shopper
    amount { rand(999) + rand.round(2) }
    completed_at { nil }

    trait :completed do
      completed_at { Time.zone.today.beginning_of_week - rand(1..6).days }
    end
  end
end
