# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Disbursement, type: :model do
  context 'associations' do
    it { is_expected.to belong_to(:merchant) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:applied_fee) }
    it { is_expected.to validate_inclusion_of(:applied_fee).in_array(described_class::AVAILABLE_FEES) }

    it { is_expected.to validate_presence_of(:total) }
    it { is_expected.to validate_presence_of(:related_week) }
  end
end
