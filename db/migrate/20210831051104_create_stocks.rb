class CreateStocks < ActiveRecord::Migration[6.0]
  def change
    create_table :stocks do |t|
      t.string :ticker, null: false
      t.string :name
      t.float :price
      t.float :closing_price
      t.float :change
      t.float :change_percent

      t.timestamps null: false
    end
  end
end
