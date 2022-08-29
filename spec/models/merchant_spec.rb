require 'rails_helper'

RSpec.describe Merchant, type: :model do

  context 'associations' do
    it { is_expected.to have_many(:orders) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:cif) }
  end
end
