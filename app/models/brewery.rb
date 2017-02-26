class Brewery < ActiveRecord::Base
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  scope :active, -> { where active:true }
  scope :retired, -> { where active:[nil,false] }

  validates :name, presence: true
  validates :year, numericality: {greater_than_or_equal_to: 1042,
                                  less_than_or_equal_to: Proc.new { Time.now.year },
                                  only_integer: true}

  def self.top(n)
    Brewery.all.sort_by{ |b| -(b.average_rating||0) }.first(n)
  end

  def print_report
    puts self.name
    puts "established at year #{self.year}"
    puts "number of beers #{self.beers.count}"
  end

  def restart
    self.year = 2017
    puts "changed year to #{year}"
  end
end
