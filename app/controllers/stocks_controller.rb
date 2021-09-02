class StocksController < ApplicationController
  def search
    if params[:stock]
      @stock = Stock.lookup(params[:stock])
      unless @stock
        flash.now[:alert] = 'Please enter a valid symbol to search'
        redirect_to root_path
      end
    else
      flash.now[:alert] = 'Please enter a ticker symbol'
      redirect_to root_path
    end
  end
end
