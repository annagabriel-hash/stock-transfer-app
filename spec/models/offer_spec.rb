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
end
