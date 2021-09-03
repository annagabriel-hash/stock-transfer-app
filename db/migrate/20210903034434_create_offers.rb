class CreateOffers < ActiveRecord::Migration[6.0]
  def change
    create_table :offers do |t|
      t.references :stock, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.float :price, null: false
      t.integer :shares, null: false
      t.integer :status, null: false, default: 0
      t.integer :type, null: false
      t.integer :action, null: false, default: 0

      t.timestamps null: false
    end
  end
end
