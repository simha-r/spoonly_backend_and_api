class Company::CardTransactionsController < Company::BaseController
  before_filter :authenticate_admin!
  before_filter :load_resource,except: [:index,:new,:create]

  def index
    @card_transactions = CardTransaction.all
  end

  def show
  end

  private

  def load_resource
    @card_transaction = CardTransaction.find params[:id]
  end

end