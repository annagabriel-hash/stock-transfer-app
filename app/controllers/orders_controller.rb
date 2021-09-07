class OrdersController < ApplicationController
  before_action :set_stock, only: %i[buy sell]

  def buy
    buy_order = @stock.buys.build(buy_stock_params)
    buy_order.user = current_user
    buy_order.price = @stock.market_price if buy_order.market_order?
    if buy_order.save
      buy_order.fulfill_order
    else
      redirect_to search_stock_path(@stock)
    end
  end

  def sell
    sell_order = @stock.sells.build(sell_stock_params)
    sell_order.user = current_user
    if sell_order.save
      sell_order.fulfill_order
    else
      redirect_to search_stock_path(@stock)
    end
  end

  private

  def set_stock
    @stock = Stock.check_db(resource[:ticker])
    if @stock.blank?
      @stock = Stock.lookup(resource[:ticker])
      @stock.save
    else
      @stock
    end
  end

  def buy_stock_params
    params.require(:buy).permit(:order_type, :price, :shares)
  end

  def sell_stock_params
    params.require(:sell).permit(:order_type, :price, :shares)
  end

  def resource
    params[:buy] || params[:sell]
  end
end
