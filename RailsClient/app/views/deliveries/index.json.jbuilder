json.array!(@deliveries) do |delivery|
  json.extract! delivery, :id
  json.url delivery_url(delivery, format: :json)
end
