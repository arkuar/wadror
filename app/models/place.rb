
class Place < OpenStruct
  def self.rendered_fields
    [:name, :status, :street, :city, :zip, :country, :overall ]
  end
end