class Stock < ApplicationRecord
  validates :ticker, presence: true

  def self.lookup(ticker_symbol)
    client = IEX::Api::Client.new
    begin
      new(ticker: ticker_symbol, name: client.company(ticker_symbol).company_name, price: client.price(ticker_symbol), change: client.quote(ticker_symbol).change, change_percent: client.quote(ticker_symbol).change_percent)
    rescue StandardError
      nil
    end
  end
end
