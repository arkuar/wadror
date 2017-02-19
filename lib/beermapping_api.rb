
class BeermappingApi
  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, expires_in: 1.week) { fetch_places_in(city) }
  end

  def self.place_by_id(id)
    Rails.cache.fetch("place_id_#{id}", expires_in: 1.week) { fetch_by_id(id) }
  end

  def self.fetch_by_id(id)
    url = "http://beermapping.com/webservice/locquery/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(id)}"
    place = response.parsed_response["bmp_locations"]["location"]
    return [] if place.is_a?(Hash) and place['id'].nil?

    Place.new(place)

  end

  def self.fetch_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do | place |
      Place.new(place)
    end
  end

  def self.get_weather_in(city)
    url = "http://api.apixu.com/v1/current.xml?key=#{apixu}&q="

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    weather = response.parsed_response['root']
    return [] if weather['location'].nil?
    return weather
  end

  def self.key
    raise "APIKEY env variable not defined" if ENV['APIKEY'].nil?
    ENV['APIKEY']
  end

  def self.googlekey
    raise "Google API env variable not defined" if ENV['GOOKEY'].nil?
    ENV['GOOKEY']
  end

  def self.apixu
    raise "APIXU API env variable not defined" if ENV['APIXU'].nil?
    ENV['APIXU']
  end
end