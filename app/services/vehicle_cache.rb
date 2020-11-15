class VehicleCache
  def inject
    Vehicle.find_each do |vehicle|
      Order.not_fullfilled.where(vehicle: vehicle).find_each do |order|
        (order.starts_at.to_date ... order.expires_at.to_date).each do |date|
          $redis.setnx(vehicle.cache_key(date.to_s), reserve_amount(vehicle, date))
        end
      end
    end
  end

  private

  def reserve_amount(vehicle, date)
    Order.not_fullfilled.where("starts_at <= :date and expires_at < :date", date: date).count(:id)
  end
end
