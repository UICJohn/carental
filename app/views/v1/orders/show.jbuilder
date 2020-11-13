json.(@order, :id, :amount)

json.created_at @order.created_at.to_s
json.starts_at  @order.starts_at.to_s
json.expires_at @order.expires_at.to_s

json.vehicle do
  json.(@order.vehicle, :price, :color)
end
json.store do
  json.(@order.store, :id, :name, :address)
  json.country @order.store.city&.country_name
  json.state @order.store.city&.state_name
  json.city @order.store.city&.name
end
