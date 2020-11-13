class Payment < ApplicationRecord
  belongs_to :order
  belongs_to :user

  validate :check_order, on: :create
  validate :can_pay?, on: :create

  def refund
    true
  end

  private

  def can_pay?
    order.pay_before > Time.zone.now
  end

  def check_order
    case order.status
    when 'closed'
      errors.add(:base, "Order has already been closed")
    when 'paid'
      errors.add(:base, "Your order has been paid. Do not resubmit the payment")
    when 'cancelled'
      errors.add(:base, "Your order has been cancelled")
    when 'refund'
      errors.add(:base, "Your order has been proccessed")
    end
  end
end
