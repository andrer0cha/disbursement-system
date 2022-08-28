# frozen_string_literal: true

FactoryBot.define do
  factory :disbursement do
    merchant { nil }
    applied_fee { '9.99' }
    total { '9.99' }
  end
end
