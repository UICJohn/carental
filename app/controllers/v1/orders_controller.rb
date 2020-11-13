class V1::OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.find_by(id: params[:id])
  end

  def create
    @order = Order.initialize_order_for(current_user, order_params.to_h)

    unless @order.persisted?
      return render json: { status: 'failed', errors: @order.errors.full_messages}
    end
  end

  def destroy
    @order = current_user.orders.find_by(id: params[:id])
    if @order.outdate?
      render json: {status: 'failed', errors: 'Sorry, we cannot cancel your order'}
    else
      @order.cancel!
      render json: {status: 'success'}
    end
  end

  private
 
  def order_params
    params.permit(:vehicle_id, :starts_at, :expires_at)
  end
end
