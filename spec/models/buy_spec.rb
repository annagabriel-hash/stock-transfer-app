require 'rails_helper'

RSpec.describe Buy, type: :model do
  subject(:buy) { build(:buy) }

  it { is_expected.to be_valid }
  it { is_expected.to be_open }
  it { is_expected.to respond_to(:amount) }

  context 'with invalid attributes' do
    it 'is not valid without order type' do
      expect(build(:buy, order_type: nil)).not_to be_valid
    end
  end

  context 'when user has insufficient balance' do
    it 'is not valid' do
      buy.shares = 100_000
      expect(buy).not_to be_valid
    end
  end
end
