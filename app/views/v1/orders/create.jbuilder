json.call(@order, :id, :amount, :status)

json.created_at @order.created_at.to_s
json.starts_at  @order.starts_at.to_s
json.expires_at @order.expires_at.to_s

json.pay_before @order.pay_before.to_s

json.vehicle do
  json.call(@order.vehicle, :price, :color)
end

json.store do
  json.call(@order.vehicle.store, :id, :name, :address)
  json.country @order.vehicle.store.city&.country_name
  json.state @order.vehicle.store.city&.state_name
  json.city @order.vehicle.store.city&.name
end
