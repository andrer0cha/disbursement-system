# frozen_string_literal: true

class CreateDisbursements < ActiveRecord::Migration[7.0]
  def change
    create_table :disbursements do |t|
      t.references :merchant, null: false, foreign_key: true
      t.decimal :applied_fee, null: false, default: 0.0
      t.decimal :total, null: false, default: 0.0

      t.timestamps
    end
  end
end
