class V1::PaymentsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    order = current_user.orders.find_by(id: params[:order_id])

    @payment = current_user.payments.new(amount: order.amount, order: order)

    if not @payment.save
      return render json: {status: 'failed', errors: @payment.errors.full_messages}
    end
  end
end