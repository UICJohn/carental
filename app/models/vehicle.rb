class Vehicle < ApplicationRecord
  belongs_to :model
  belongs_to :store
  has_many   :orders

  delegate :brand, to: :model

  # def decrease_cache_amount(dates)
  #   File.open(Rails.root.join("app", "scripts", "decreament.lua")) do |file|
  #     script = file.read()

  #     $redis.eval(script, dates.map{|date| key(date)}, amount_left(dates))
  #   end
  # end

  # def amount_left(dates)
  #   dates.map do |date|
  #     amount - orders.not_fullfilled.where("starts_at <= :date and expires_at >= :date", date)
  #   end
  # end

  # def increase_cache_amount
  #   $redis.incr(key)
  # end

  # def cache_amount
  #   $redis.get(key)
  # end

  # def key(date)
  #   "Vehicle:#{self.id}:#{date.to_s}:amount"
  # end
end
