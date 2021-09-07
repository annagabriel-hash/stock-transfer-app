require 'rails_helper'

RSpec.describe 'BuyStocks', type: :system do
  let(:broker_user) { create(:user, :broker) }
  let(:stock) { Stock.find_by(ticker: 'MSFT') }

  before do
    driven_by(:rack_test)
    create(:role, :broker)
    create(:role, :admin)
    sign_in broker_user
    search_stock
    buy_stock
  end

  context 'with valid stock' do
    let(:buy_order) { Buy.find_by(user: broker_user, stock: stock) }
    let(:trade) { Trade.where(buy: buy_order, stock: stock) }

    it 'buys stock' do
      expect(Buy.count).to eq(1)
    end

    it 'saves stock shares bought' do
      expect(buy_order.shares).to eq(10)
    end

    it 'saves stock share price' do
      expect(buy_order.price).to eq(stock.market_price)
    end

    it 'creates trade' do
      expect(trade).to exist
    end

    it 'updates user stock' do
      user_stock = UserStock.find_by(user: broker_user, stock: stock)
      expect(user_stock.shares).to eq(trade.first.shares)
    end

    it 'updates user balance' do
      new_balance = broker_user.balance - trade.first.amount
      expect(broker_user.reload.balance).to eq(new_balance)
    end
  end
end
