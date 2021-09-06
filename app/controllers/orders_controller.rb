class OrdersController < ApplicationController
  before_action :set_stock, only: %i[create]

  def create
    buy_order = @stock.buys.create(stock: @stock, order_type: 0, user: current_user, price: @stock.market_price, shares: params[:shares])
    return if buy_order.matching_orders.any?

    buy_order.fulfill_order
    trade = buy_order.trades.last
    current_user.update(balance: trade.new_balance)
  end

  private

  def set_stock
    @stock = Stock.check_db(params[:ticker])
    if @stock.blank?
      @stock = Stock.lookup(params[:ticker])
      @stock.save
    else
      @stock
    end
  end

  def stock_params
    params.require(:buy).permit(:price, :shares)
  end
end
