class StockOrdersController < ApplicationController
  def create
    @stock = Stock.find(params[:stock_id])
    @stock_order = @stock.stock_orders.create(stock_order_params)
    redirect_to stock_path(@stock)
  end

  def destroy
    @stock = Stock.find(params[:stock_id])
    @stock_order = @stock.stock_orders.find(params[:id])
    @stock_order.destroy
    redirect_to stock_path(@stock), status: :see_other
  end

  private
    def stock_order_params
      params.require(:stock_order).permit(:units, :unit_cost, :date, :account_provider_id)
    end
end
