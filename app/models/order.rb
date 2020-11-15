class Order < ApplicationRecord
  enum status: { pending: 0, paid: 1, closed: 2, cancelled: 3, refunded: 4 }
  has_one :payment
  belongs_to :user
  belongs_to :vehicle
  delegate :store, to: :vehicle

  validate :check_date, on: :create
  validate :check_orders, on: :create

  scope :not_fullfilled, -> { where('(status = ? OR status = ?) AND expires_at >= ?', 0, 1, Time.zone.now) }
  scope :fullfilled, -> { where("(status && ?) and expires_at < ?", '{2, 3, 4}', Time.zone.now)}

  def self.initialize_order_for(user, options)
    order = new(options.to_h.merge({ user: user }))

    order.vehicle.reserve!(options[:starts_at], options[:expires_at]) do |result|
      unless result.negative?
        if order.valid?
          order.amount = ((order.expires_at.beginning_of_day - order.starts_at.end_of_day) / 3600 / 24).ceil * order.vehicle.price
          order.save
          CheckPaymentWorker.perform_in(10.minutes, order.id)
        end
      else
        order.errors.add(:amount, 'Vehicle out of stock')
      end
    end

    order
  end

  def cancel!
    if !closed? || !renfund?
      update(status: :cancelled)
      # #TODO PAYMENT REFUND
    end
  end

  def outdate?
    Time.zone.now > 1.day.ago(starts_at)
  end

  def pay_before
    10.minutes.since(created_at)
  end

  private

  def check_orders
    (starts_at.to_date...expires_at.to_date).each do |date|
      orders_count = vehicle.orders.not_fullfilled.where('starts_at <= :date and expires_at >= :date', { date: date }).count(:id)

      if vehicle.amount <= orders_count
        errors.add(:base, "Vehicle out of stock at #{date.to_date}")
      end
    end

    if user.orders.not_fullfilled.where("(starts_at >= :starts_at AND starts_at < :expires_at) OR
          (starts_at <= :starts_at AND expires_at >= :starts_at)", { starts_at: starts_at, expires_at: expires_at }).present?

      errors.add(:base, 'You have another order')
    end
  end

  def check_date
    if expires_at < starts_at
      errors.add(:expires_at, 'expires date cannot before pick up date')
    end

    if starts_at.to_date < Time.zone.now.to_date
      errors.add(:starts_at, 'invalid start date')
    end
  end
end
