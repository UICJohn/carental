class VehiclesSearch
  include ActionView::Helpers::SanitizeHelper
  include ActiveModel::Model

  attr_accessor :pick_up_store_id, :starts_at, :expires_at

  def search
    vehicles = if (store = Store.find_by(id: pick_up_store_id)).present?
                 store.vehicles.where(active: true)
               else
                 Vehicle.where(active: true)
               end

    return vehicles if store.blank?

    if starts_at.present? && expires_at.present?
      vehicles.map do |vehicle|
        vehicle if vehicle_available?(vehicle)
      end.compact
    end
  end

  private

  def vehicle_available?(vehicle)
    (starts_at.to_date...expires_at.to_date).each do |date|
      orders_count = Order.where(vehicle: vehicle).where('starts_at <= :date AND expires_at >= :date', { date: date.beginning_of_day }).count
      return false if vehicle.amount <= orders_count
    end

    true
  end
end
