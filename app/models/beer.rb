class Beer < ActiveRecord::Base
  include RatingAverage

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
  belongs_to :style

  validates :name, presence: true
  validates :style, presence: true

  def self.top(n)
    Beer.all.sort_by{ |b| -(b.average_rating || 0) }.first(n)
  end

  def to_s
    "#{name} #{brewery.name}"
  end
end
