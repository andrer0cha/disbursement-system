# frozen_string_literal: true

module Calculators
  class LastWeekDisbursement
    def call
      current_disbursements = ::Disbursement.all.count
      merchants.each do |merchant|
        Rails.logger.debug "Processing data for merchant: #{merchant.id}"
        Rails.logger.debug "    Number of orders: #{merchant.orders.size}"
        total = merchant.orders.sum(:amount)

        next if ::Disbursement.where(merchant:, related_week: start_date.to_date.cweek).any?

        ::Disbursement.create!(
          merchant:,
          applied_fee: fee_value(total),
          total: (fee_value(total) * total),
          related_week: start_date.to_date.cweek
        )
      end
      Rails.logger.debug "#{::Disbursement.all.count - current_disbursements} disbursements created."
    end
    handle_asynchronously :call

    private

    def merchants
      @merchants ||= Merchant.includes(:orders).where(orders: { completed_at: start_date..end_date }).where.not(orders: { completed_at: nil })
    end

    def start_date
      (Time.zone.today.beginning_of_week - 1.week).beginning_of_day
    end

    def end_date
      (Time.zone.today.end_of_week - 1.week).end_of_day
    end

    def fee_value(amount)
      return nil if amount.negative?

      case amount
      when 0...50
        0.01
      when 50..300
        0.0095
      else
        0.0085
      end
    end
  end
end
