class CreatePrices < ActiveRecord::Migration[6.0]
  def change
    create_table :prices do |t|
      t.references :stocks, null: false, foreign_key: true
      t.date :period, null: false
      t.float :open
      t.float :high
      t.float :low
      t.float :close

      t.timestamps null: false
    end
  end
end
