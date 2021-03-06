require 'rails_helper'

RSpec.describe 'ViewStocks', vcr: { cassette_name: 'price/msft' }, type: :system do
  let(:buyer_user) { create(:user) }
  let(:stock) { Stock.find_by(ticker: 'MSFT') }

  before do
    driven_by(:rack_test)
    create(:role, :broker)
    create(:role, :admin)
    sign_in buyer_user
    visit root_path
  end

  context 'with valid stock' do
    it 'views stock information' do
      fill_in 'Enter stock ticker symbol', with: 'MSFT'
      find_button('button').click
      expect(page).to have_content 'Microsoft Corporation'
    end
  end

  context 'with blank stock' do
    it 'displays error message' do
      fill_in 'Enter stock ticker symbol', with: ' '
      find_button('button').click
      expect(page).to have_current_path(root_path)
    end
  end

  context 'with invalid stock' do
    it 'displays error message' do
      fill_in 'Enter stock ticker symbol', with: 'ada'
      find_button('button').click
      expect(page).to have_content 'Please enter a valid symbol to search'
    end
  end
end
