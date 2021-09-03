require 'rails_helper'

RSpec.describe Offer, type: :model do
  subject(:offer) { build(:offer) }

  before do
    create(:role)
  end

  it { is_expected.to be_valid }
  it { is_expected.to be_open }
  it { is_expected.to be_market_order }
  it { is_expected.to be_buy }

  context 'with invalid attributes' do
    it 'is not valid without order type' do
      offer.type = nil
      expect(offer).not_to be_valid
    end

    it 'is not valid without action' do
      offer.action = nil
      expect(offer).not_to be_valid
    end
  end
end
