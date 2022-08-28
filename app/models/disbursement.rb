# frozen_string_literal: true

class Disbursement < ApplicationRecord
  AVAILABLE_FEES = [1, 0.95, 0.85].freeze

  belongs_to :merchant

  validates :applied_fee, presence: true, inclusion: { in: AVAILABLE_FEES }
  validates :total, presence: true
end
