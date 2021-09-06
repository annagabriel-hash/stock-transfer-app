require 'rails_helper'

RSpec.describe Trade, type: :model do
  subject(:trade) { build(:trade) }

  it { is_expected.to respond_to(:amount) }
  it { is_expected.to respond_to(:new_balance) }

  it 'is calculates trade amount' do
    amount = trade.price * trade.shares
    expect(trade.amount).to eq(amount)
  end

  it 'is calculates new user balance' do
    new_balance = trade.buy.user.balance - trade.buy.amount
    expect(trade.new_balance).to eq(new_balance)
  end

  context 'with valid attributes' do
    before { create(:role) }

    it { is_expected.to be_valid }
  end

  context 'with invalid attributes' do
    it 'is not valid without buy order' do
      trade.buy = nil
      expect(trade).not_to be_valid
    end

    it 'is not valid without price' do
      trade.price = nil
      expect(trade).not_to be_valid
    end

    it 'is not valid without shares' do
      trade.shares = nil
      expect(trade).not_to be_valid
    end
  end
end
