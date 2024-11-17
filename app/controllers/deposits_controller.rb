class DepositsController < ApplicationController
  def index
    @deposits = Deposit.all
  end

  def show
    @deposit = Deposit.find(params[:id])
  end

  def new
    @deposit = Deposit.new
  end

  def create
    @deposit = Deposit.new(deposit_params)

    if @deposit.save
      redirect_to @deposit
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @deposit = Deposit.find(params[:id])
  end

  def update
    @deposit = Deposit.find(params[:id])

    if @deposit.update(deposit_params)
      redirect_to @deposit
    else
      render :edit
    end
  end

  def destroy
    @deposit = Deposit.find(params[:id])
    @deposit.destroy

    redirect_to deposits_path
  end

  private
    def deposit_params
      params.require(:deposit).permit(:name, :apr, :tax, :open_date, :maturity_date, :start_balance, :currency, :account_provider_id)
    end
end
