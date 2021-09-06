class StocksController < ApplicationController
  def search
    if params[:ticker]
      @stock = Stock.lookup(params[:ticker])
      unless @stock
        flash[:alert] = 'Please enter a valid symbol to search'
        redirect_to root_path
      end
    else
      flash[:alert] = 'Please enter a ticker symbol'
      redirect_to root_path
    end
  end
end
