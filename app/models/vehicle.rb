class Vehicle < ApplicationRecord
  belongs_to :model
  belongs_to :store
  has_many   :orders

  delegate :brand, to: :model

  def decrease_cache_amount(dates)
    File.open(Rails.root.join("app", "scripts", "decreament.lua")) do |file|
      script = file.read()

      $redis.eval(script, dates.map{|date| key(date)}, amount_left(dates))
    end
  end

  # def amount_left(dates)
  #   dates.map do |date|
  #     amount - orders.not_fullfilled.where("starts_at <= :date and expires_at >= :date", date)
  #   end
  # end

  def increase_cache_amount
    $redis.incr(key)
  end

  def cache_amount(dates)
    dates.map{ |date| }
    
  end

  private

  def daily_cache_amount(date)
    $redis.get key(date.to_s)
  end

  def key(postfix)
    "Vehicle:#{self.id}:amount:#{postfix}"
  end
end
