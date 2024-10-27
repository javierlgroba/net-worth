
class StocksController < ApplicationController
  def index
    @stocks = Stock.all
  end

  def show
    @stock = Stock.find(params[:id])
  end

  def new
    @stock = Stock.new
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
    ticker_data = YfinanceWrapperService::Ticker.get_info(params[:symbol])
    if !ticker_data.key?("error")
      @ticker_data = ticker_data
      render :preview
    else
      redirect_to new_stock_path, alert: "Could not fetch stock data for the provided symbol."
    end
  end

  private
    def stock_params
      params.require(:stock).permit(:symbol, :alias, :currency)
    end
end
