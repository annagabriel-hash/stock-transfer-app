class CreateTrade < ActiveRecord::Migration[6.0]
  def change
    create_table :trades do |t|
      t.references :stock, null: false, foreign_key: true
      t.references :buy, null: false, foreign_key: true
      t.references :sell, foreign_key: true
      t.float :price, null: false
      t.integer :shares, null: false

      t.timestamps null: false
    end
  end
end
