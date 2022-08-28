class CreateMerchants < ActiveRecord::Migration[7.0]
  def change
    create_table :merchants do |t|
      t.string :name, null: false, default: ''
      t.string :email, null: false, default: ''
      t.string :cif, null: false, default: ''

      t.timestamps
    end
  end
end
