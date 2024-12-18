class AccountsController < ApplicationController
  before_action :load_account, only: [ :show, :destroy ]

  def index
    @accounts = Account.all
  end

  def show
  end

  def destroy
    @account.destroy

    redirect_to accounts_path, notice: t(".success")
  end

  private

  def load_account
    @account = Account.find(params[:id])
  end
end
