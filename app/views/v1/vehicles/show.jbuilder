json.(@vehicle, :id, :price, :amount, :color)
json.model do
  json.brand @vehicle.model.brand.name
  json.name @vehicle.model.name
  json.year @vehicle.model.year
end
json.store do
  json.(@vehicle.store, :id, :name, :address)
  json.country @vehicle.store.city&.country_name
  json.state @vehicle.store.city&.state_name
  json.city @vehicle.store.city&.name
end
