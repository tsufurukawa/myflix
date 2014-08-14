class Admin::PaymentsController < AdminsController
  def index
    @payments = Payment.limit(10).reverse_order
  end
end