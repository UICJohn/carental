class CheckPaymentWorker
  include Sidekiq::Worker

  sidekiq_options retry: 2

  def perform(order_id)
    order = Order.find_by(id: order_id, status: :pending)

    return unless order.present?

    order.with_lock do
      if order.pending and order.update(status: :closed)
        order.vehicle.increase_cache_amount
      end
    end
    
  end
end