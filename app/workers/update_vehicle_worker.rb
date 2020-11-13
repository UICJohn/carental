class UpdateVehicleWorker
  include Sidekiq::Worker

  sidekiq_options retry: 2

  def perform(vehicle_id)
    vehicle = Vehicle.find_by(id: vehicle_id)

    return if order.blank?

    begin
      vehicle.with_lock do
        vehicle.update(amount: vehicle.cache_amount)
      end
    rescue ActiveRecord::StaleObjectError => e
    end
  end
end
