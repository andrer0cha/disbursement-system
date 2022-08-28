# frozen_string_literal: true

class CreateShoppers < ActiveRecord::Migration[7.0]
  def change
    create_table :shoppers do |t|
      t.string :name, null: false, default: ''
      t.string :email, null: false, default: ''
      t.string :nif, null: false, default: ''

      t.timestamps
    end
  end
end
