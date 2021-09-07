require 'rails_helper'

RSpec.describe 'ViewPortfolios', vcr: { cassette_name: 'price/msft' }, type: :system do
  include ActionView::Helpers::NumberHelper

  let(:broker_user) { create(:user, :broker) }
  let(:stock) { Stock.find_by(ticker: 'MSFT') }
  let(:user_stock) { UserStock.find_by(user: broker_user, stock: stock) }

  before do
    driven_by(:rack_test)
    create(:role, :admin)
    create(:stock)
    buy_order = create(:buy, user: broker_user, stock: stock, shares: 10, order_type: 0)
    create(:trade, stock: stock, shares: 10, buy: buy_order)
    stock.update(market_price: 350)
    sign_in broker_user
    visit root_path
    click_on 'Portfolio'
  end

  context 'with stock' do
    it 'displays stock ticker' do
      expect(page).to have_content(stock.ticker)
    end

    it 'displays shares' do
      expect(page).to have_content(number_with_delimiter(user_stock.shares))
    end

    it 'displays market price' do
      expect(page).to have_content(number_to_currency(stock.market_price))
    end

    it 'displays total value' do
      total_value = stock.market_price * broker_user.shares(stock)
      expect(page).to have_content(number_to_currency(total_value))
    end
  end
end
