require 'rails_helper'

RSpec.describe 'BuyLimitOrder', vcr: { cassette_name: 'price/msft' }, type: :system do
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
    subject(:buy_order) { Buy.find_by(user: broker_user, stock: stock) }

    let(:trade) { Trade.where(buy: buy_order, stock: stock) }

    before { buy_limit_order }

    it 'buys stock' do
      expect(Buy.count).to eq(1)
    end

    it { is_expected.to have_attributes(shares: 10, price: 350) }
    it { is_expected.to be_open }

    context 'without matching orders' do
      it 'has no matching orders' do
        expect(buy_order.matching_orders).not_to be_present
      end

      it 'has no trade' do
        expect(trade).not_to exist
      end

      it 'has same buyer stock' do
        expect(broker_user.shares(stock)).to be_zero
      end

      it 'has same buyer balance' do
        expect(broker_user.reload.balance).not_to be < 100_000
      end
    end

    context 'with matching orders' do
      let(:seller_user) { create(:random_user) }
      let(:sell_order) { Sell.find_by(user: seller_user, stock: stock) }

      before do
        create(:user_stock, user: seller_user, stock: stock, shares: 50)
        create(:sell, user: seller_user, stock: stock, shares: 10, price: 350)
        sell_order.fulfill_order
      end

      it 'has closed sell order' do
        expect(sell_order).to be_close
      end

      it 'has closed buy order' do
        expect(buy_order).to be_close
      end

      it 'has trade' do
        expect(trade).to exist
      end

      it 'has buyer with added stock' do
        expect(broker_user.shares(stock)).to eq 10
      end

      it 'has buyer with updated balance' do
        beg_balance = 100_000
        new_balance = beg_balance - trade.first.amount
        expect(broker_user.reload.balance).to eq new_balance
      end

      it 'has seller with reduced stock' do
        expect(seller_user.shares(stock)).to eq 40
      end

      it 'has seller with updated balance' do
        beg_balance = 100_000
        new_balance = beg_balance + trade.first.amount
        expect(seller_user.reload.balance).to eq new_balance
      end
    end
  end

  context 'with insufficient balance' do
    before do
      within '#buy_market_order_form' do
        fill_in 'Shares', with: 10_000
        click_on 'Buy MSFT'
      end
    end

    it 'no buy limit order' do
      expect(Buy.count).to be_zero
    end
  end
end
