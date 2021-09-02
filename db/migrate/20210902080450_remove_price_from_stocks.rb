class RemovePriceFromStocks < ActiveRecord::Migration[6.0]
  def change
    rename_column :stocks, :price, :market_price
    remove_column :stocks, :closing_price, :float
    remove_column :stocks, :change, :float
    remove_column :stocks, :change_percent, :float
  end
end
