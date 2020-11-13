json.array! @stores do |store|
  json.call(store, :id, :name, :address)
  json.country store.city&.country_name
  json.state   store.city&.state&.name
  json.city    store.city&.name
end
