class CreateSell < ActiveRecord::Migration[6.0]
  def change
    create_table :sells do |t|
      t.references :stock, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.float :price, null: false
      t.integer :shares, null: false
      t.integer :status, null: false, default: 0
      t.integer :order_type, null: false

      t.timestamps null: false
    end
  end
end
