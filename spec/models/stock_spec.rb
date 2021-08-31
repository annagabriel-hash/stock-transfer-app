require 'rails_helper'

RSpec.describe Stock, type: :model do
  context 'with valid attributes' do
    subject(:stock) { build(:stock) }

    it { is_expected.to be_valid }
  end

  context 'with invalid attributes' do
    subject(:stock) { build(:stock, ticker: '') }

    it { is_expected.not_to be_valid }
  end
end
