json.array!(@breweries) do |brewery|
  json.extract! brewery, :id, :name, :year
  json.beer_amount brewery.beers.count
  json.active brewery.active
end