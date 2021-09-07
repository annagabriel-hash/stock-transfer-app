require 'rails_helper'

RSpec.describe 'BuyMarketOrder', vcr: { cassette_name: 'price/msft' }, type: :system do
  let(:broker_user) { create(:user, :broker) }
  let(:stock) { Stock.find_by(ticker: 'MSFT') }

  before do
    driven_by(:rack_test)
    create(:role, :broker)
    create(:role, :admin)
    sign_in broker_user
    search_stock
  end

  context 'with valid stock' do
    let(:buy_order) { Buy.find_by(user: broker_user, stock: stock) }
    let(:trade) { Trade.where(buy: buy_order, stock: stock) }

    before { buy_market_order }

    it 'has saved market order' do
      expect(Buy.count).to eq(1)
    end

    it 'is a market order' do
      expect(buy_order).to be_market_order
    end

    it 'saves stock shares bought' do
      expect(buy_order.shares).to eq(10)
    end

    it 'saves stock share price' do
      expect(buy_order.price).to eq(stock.market_price)
    end

    it 'has trade' do
      expect(trade).to exist
    end

    it 'has buyer with added stock' do
      expect(broker_user.shares(stock)).to eq(trade.first.shares)
    end

    it 'has buyer with updated balance' do
      beg_balance = 100_000
      new_balance = beg_balance - trade.first.amount
      expect(broker_user.reload.balance).to eq(new_balance)
    end
  end

  context 'with insufficient balance' do
    before do
      within '#buy_market_order_form' do
        fill_in 'Shares', with: 10_000
        click_on 'Buy MSFT'
      end
    end

    it 'has no buy order' do
      expect(Buy.count).to be_zero
    end
  end
end
