# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Calculators::LastWeekDisbursement, :run_delayed_jobs do
  let!(:completed_orders) do
    create_list :order, completed_orders_count, :completed
  end
  let(:completed_orders_count) { 10 }

  subject(:calculator_service) { described_class.new }

  it 'creates disbursements for all completed orders in the previous week' do
    expect { calculator_service.call }.to change(Disbursement, :count).from(0).to(completed_orders_count)
  end

  context 'when the order amount is less than 50' do
    let(:cheap_orders) do
      completed_orders.select { |x| x.amount < 50 }
    end

    it 'sets the applied fee as 0.01' do
      calculator_service.call
      created_disbursements = Disbursement.all.where(merchant_id: cheap_orders.pluck(:merchant_id))

      expect(created_disbursements.pluck(:applied_fee).uniq[0].to_f).to eq 0.01
    end

    it 'sets the total as (order.amount)*0.01' do
      calculator_service.call
      created_disbursements = Disbursement.all.where(merchant_id: cheap_orders.pluck(:merchant_id))

      aggregate_failures do
        created_disbursements.each do |created_disbursement|
          order_disbursements = cheap_orders.select do |co|
            co.merchant_id == created_disbursement.merchant_id && !co.completed_at.nil?
          end

          expect(order_disbursements.pluck(:amount).sum).to eq((created_disbursement.total / 0.01).to_f)
        end
      end
    end
  end

  context 'when the order amount is greather or equal 50 and less than or equal 300' do
    let(:medium_orders) do
      completed_orders.select { |x| x.amount >= 50 && x.amount <= 300 }
    end

    it 'sets the applied fee as 0.0095' do
      calculator_service.call
      created_disbursements = Disbursement.all.where(merchant_id: medium_orders.pluck(:merchant_id))

      expect(created_disbursements.pluck(:applied_fee).uniq[0].to_f).to eq 0.0095
    end

    it 'sets the total as (order.amount)*0.0095' do
      calculator_service.call
      created_disbursements = Disbursement.all.where(merchant_id: medium_orders.pluck(:merchant_id))

      aggregate_failures do
        created_disbursements.each do |created_disbursement|
          order_disbursements = medium_orders.select do |mo|
            mo.merchant_id == created_disbursement.merchant_id && !mo.completed_at.nil?
          end

          expect(order_disbursements.pluck(:amount).sum).to eq((created_disbursement.total / 0.0095).to_f)
        end
      end
    end
  end

  context 'when the order amount is greather than 300' do
    let(:expensive_orders) do
      completed_orders.select { |x| x.amount > 300 }
    end

    it 'sets the applied fee as 0.0085' do
      calculator_service.call
      created_disbursements = Disbursement.all.where(merchant_id: expensive_orders.pluck(:merchant_id))

      expect(created_disbursements.pluck(:applied_fee).uniq[0].to_f).to eq 0.0085
    end

    it 'sets the total as (order.amount)*0.0085' do
      calculator_service.call
      created_disbursements = Disbursement.all.where(merchant_id: expensive_orders.pluck(:merchant_id))

      aggregate_failures do
        created_disbursements.each do |created_disbursement|
          order_disbursements = expensive_orders.select do |eo|
            eo.merchant_id == created_disbursement.merchant_id && !eo.completed_at.nil?
          end

          expect(order_disbursements.pluck(:amount).sum).to eq((created_disbursement.total / 0.0085).to_f)
        end
      end
    end
  end

  context 'when the merchant has more than one completed order in the previous week' do
    before do
      create :order, :completed, merchant: completed_orders.last.merchant
    end

    it 'creates only one disbursement related to all orders' do
      calculator_service.call
      created_disbursements = Disbursement.all

      aggregate_failures do
        expect(created_disbursements.group(:merchant_id).count.values.uniq).to eq([1])
        expect(created_disbursements.size).to eq(completed_orders_count)
      end
    end
  end

  context 'when the order is not completed in the previous week' do
    let!(:incompleted_orders) do
      create_list :order, completed_orders_count
    end

    before do
      completed_orders.map(&:destroy)
    end

    it 'does not create disbursements' do
      expect { calculator_service.call }.not_to change(Disbursement, :count)
    end
  end
end
