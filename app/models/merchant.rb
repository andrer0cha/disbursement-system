# frozen_string_literal: true

class Merchant < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true
  validates :cif, presence: true

  has_many :orders
end
