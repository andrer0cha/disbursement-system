# frozen_string_literal: true

class Disbursement < ApplicationRecord
  AVAILABLE_FEES = [0.01, 0.0095, 0.0085].freeze

  belongs_to :merchant

  validates :applied_fee, presence: true, inclusion: { in: AVAILABLE_FEES }
  validates :total, presence: true
end
