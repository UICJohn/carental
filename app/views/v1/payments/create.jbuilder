json.(@payment, :id, :amount)
json.created_at @payment.created_at.to_s