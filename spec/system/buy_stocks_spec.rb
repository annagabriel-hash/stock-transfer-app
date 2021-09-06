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
  end

  context 'with valid stock' do
    it 'buys stock' do
      fill_in 'Shares', with: 10
      expect { click_on 'Buy MSFT' }.to change(Buy, :count).to eq(1)
    end

    it 'creates trade' do
      fill_in 'Shares', with: 10
      expect { click_on 'Buy MSFT' }.to change(Trade, :count).to eq(1)
    end

    it 'updates user stock' do
      fill_in 'Shares', with: 10
      click_on 'Buy MSFT'
      trade = Trade.last
      user_stock = UserStock.find_by(user: broker_user, stock: stock)
      expect(user_stock.shares).to eq(trade.shares)
    end

    it 'updates user balance' do
      fill_in 'Shares', with: 10
      click_on 'Buy MSFT'
      trade = Trade.last
      new_balance = broker_user.balance - trade.amount
      expect(broker_user.reload.balance).to eq(new_balance)
    end
  end
end
