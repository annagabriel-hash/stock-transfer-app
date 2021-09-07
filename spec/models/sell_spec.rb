require 'rails_helper'

RSpec.describe Sell, type: :model do
  subject(:sell) { build(:sell, stock: stock, user: user) }

  let(:user) { create(:user) }
  let(:stock) { create(:stock) }
  let(:buy) { create(:buy, user: user) }

  before do
    create(:user_stock, user: user, stock: stock)
  end

  it { is_expected.to be_valid }
  it { is_expected.to be_open }
  it { is_expected.to respond_to(:amount) }
  it { is_expected.to respond_to(:fulfill_order) }
  it { is_expected.to respond_to(:matching_orders) }

  it 'calculates amount' do
    amount = sell.price * sell.shares
    expect(sell.amount).to eq(amount)
  end

  it 'shows matching buy orders' do
    expect(sell.matching_orders).to match_array([buy])
  end

  context 'with invalid attributes' do
    it 'is not valid without order type' do
      expect(build(:sell, order_type: nil)).not_to be_valid
    end
  end

  context 'when user has insufficient shares' do
    it 'is not valid' do
      sell.shares = 100_000
      expect(sell).not_to be_valid
    end
  end

  context 'when order is fulfilled' do
    subject(:sell) { create(:sell, stock: stock, user: user) }

    before do
      create(:buy, user: user)
    end

    it 'creates a trade' do
      expect { sell.fulfill_order }.to change(Trade, :count).by(1)
    end

    it 'closes order' do
      sell.fulfill_order
      expect(sell.close?).to be true
    end
  end
end
