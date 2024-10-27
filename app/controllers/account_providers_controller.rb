class AccountProvidersController < ApplicationController
  def index
    @account_providers = AccountProvider.all
  end

  def show
    @account_provider = AccountProvider.find(params[:id])
  end

  def new
    @account_provider = AccountProvider.new
  end

  def create
    @account_provider = AccountProvider.new(account_provider_params)

    if @account_provider.save
      redirect_to @account_provider
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @account_provider = AccountProvider.find(params[:id])
  end

  def update
    @account_provider = AccountProvider.find(params[:id])

    if @account_provider.update(account_provider_params)
      redirect_to @account_provider
    else
      render :edit
    end
  end

  def destroy
    @account_provider = AccountProvider.find(params[:id])
    @account_provider.destroy

    redirect_to account_providers_path
  end

  private
    def account_provider_params
      params.require(:account_provider).permit(:name, :country, :provider_type)
    end
end
