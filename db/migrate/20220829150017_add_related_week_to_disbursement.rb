# frozen_string_literal: true

class AddRelatedWeekToDisbursement < ActiveRecord::Migration[7.0]
  def change
    add_column :disbursements, :related_week, :integer, null: false, default: 0
  end
end
