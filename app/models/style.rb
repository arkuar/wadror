class Style < ActiveRecord::Base
  include RatingAverage

  has_many :beers, dependent: :destroy

end
