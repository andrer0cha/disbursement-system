# frozen_string_literal: true

namespace :calculators do
  desc 'Calculate last week Disbursement per Merchant'
  task weekly_disbursement: :environment do
    ::Calculators::LastWeekDisbursement.new.call
  end
end
