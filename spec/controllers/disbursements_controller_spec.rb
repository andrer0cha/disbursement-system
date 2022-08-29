# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DisbursementsController, :run_delayed_jobs do
  describe 'GET #index' do
    subject(:index) { get :index, params: }

    let(:params) { {} }

    let!(:merchants) do
      create_list :merchant, 10, :with_orders
    end
    let!(:disbursements) { ::Calculators::LastWeekDisbursement.new.call }
    let(:expected_keys) { %w[id merchant_id applied_fee total created_at updated_at] }

    it 'returns 200 OK' do
      index

      expect(response).to be_ok
    end

    it 'returns all the expected attributes' do
      index

      expect(JSON.parse(response.body)[0].keys).to match_array(expected_keys)
    end

    context 'when the e-mail is not given' do
      it 'returns the disbursement for all the merchants' do
        index

        returned_disbursements = JSON.parse(response.body)

        expect(returned_disbursements.size).to eq(Disbursement.all.count)
      end
    end

    context 'when the e-mail is given as a query param' do
      let(:params) do
        {
          email: merchants.fifth.email
        }
      end
      let(:merchant_id) { Merchant.find_by(email: merchants.fifth.email).id }

      it 'returns only the disrbursements for the specified merchant' do
        index

        returned_disbursements = JSON.parse(response.body)
        expected_disbursements = Disbursement.where(merchant_id:)

        aggregate_failures do
          expect(returned_disbursements.size).to eq(expected_disbursements.size)
          expect(returned_disbursements.pluck('merchant_id').uniq[0]).to eq(merchant_id)
        end
      end
    end
  end
end
