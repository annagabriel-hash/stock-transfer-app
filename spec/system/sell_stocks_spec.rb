require 'rails_helper'

RSpec.describe 'SellStocks', type: :system do
  let(:stock) { create(:stock) }
  let(:broker_user) { create(:user, :broker) }
  let(:sell_order) { Sell.find_by(user: broker_user, stock: stock) }

  before do
    driven_by(:rack_test)
    create(:role, :broker)
    create(:role, :admin)
    create(:user_stock, user: broker_user, stock: stock)
    sign_in broker_user
    search_stock
  end

  context 'with valid stock' do
    subject { sell_order }

    before { sell_stock }

    it { is_expected.to be_present }
    it { is_expected.to have_attributes(price: 350, shares: 10) }
    it { is_expected.to be_open }
  end

  context 'when there is a matching buy order' do
    subject(:trade) { Trade.find_by(sell: sell_order, stock: stock, buy: buy_order) }

    let(:buyer_user) { create(:random_user) }
    let!(:buy_order) { create(:buy, user: buyer_user, stock: stock, shares: 10, price: 350) }

    before { sell_stock }

    it { is_expected.to be_present }

    it 'has close orders', :aggregate_failures do
      expect(trade.buy).to be_close
      expect(trade.sell).to be_close
    end

    it 'updates seller balance' do
      beg_balance = 100_000
      new_balance = beg_balance + trade.amount
      expect(broker_user.reload.balance).to eq new_balance
    end

    it 'updates seller stock' do
      new_stock = 20_000 - trade.shares
      seller_stock = UserStock.find_by(user: broker_user, stock: stock)
      expect(seller_stock.shares).to eq(new_stock)
    end

    it 'updates buyer_balance' do
      beg_balance = 100_000
      new_balance = beg_balance - trade.amount
      expect(buyer_user.reload.balance).to eq new_balance
    end

    it 'updates buyer stock' do
      new_stock = 0 + trade.shares
      buyer_stock = UserStock.find_by(user: buyer_user, stock: stock)
      expect(buyer_stock.shares).to eq(new_stock)
    end
  end
end