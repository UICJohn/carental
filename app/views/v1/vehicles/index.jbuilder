json.array! @vehicles do |vehicle|
  json.(vehicle, :id, :price, :amount, :color)
  json.model vehicle.model.name
  json.brand vehicle.model.brand.name
  json.store do
    json.(vehicle.store, :id, :name, :address)
    json.country vehicle.store.city&.country_name
    json.state vehicle.store.city&.state_name
    json.city vehicle.store.city&.name
  end
end
