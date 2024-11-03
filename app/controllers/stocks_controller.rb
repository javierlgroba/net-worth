
class StocksController < ApplicationController
  def index
    @portfolio_data = StockService::Portfolio.history
  end

  def show
    @stock = Stock.find(params[:id])
    @stock_data = StockService::Stock.get_info(@stock)
  end

  def new
  end

  def create
    @stock = Stock.new(stock_params)

    if @stock.save
      redirect_to @stock
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @stock = Stock.find(params[:id])
  end

  def update
    @stock = Stock.find(params[:id])

    if @stock.update(stock_params)
      redirect_to @stock
    else
      render :edit
    end
  end

  def destroy
    @stock = Stock.find(params[:id])
    @stock.destroy

    redirect_to stocks_path
  end

  def preview
    symbol_data = StockService::Stock.preview(params[:symbol])
    redirect_to new_stock_path, alert: "Could not fetch stock data for the provided symbol." if symbol_data.empty?
    @stock = Stock.new(symbol: params[:symbol], alias: symbol_data[:name], currency: symbol_data[:currency])
  end

  private
    def stock_params
      params.require(:stock).permit(:symbol, :alias, :currency)
    end
end
