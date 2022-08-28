# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Order, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:merchant) }
    it { is_expected.to belong_to(:shoper) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:amount) }
  end
end
