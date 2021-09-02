class Stock < ApplicationRecord
  validates :ticker, presence: true
  has_many :prices, dependent: :destroy
  has_many :user_stocks, dependent: :destroy
  has_many :users, through: :user_stocks

  def self.lookup(ticker_symbol)
    client = IEX::Api::Client.new
    begin
      new(ticker: ticker_symbol, name: client.company(ticker_symbol).company_name, market_price: client.price(ticker_symbol))
    rescue StandardError
      nil
    end
  end
end
