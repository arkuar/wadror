class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
            length: {minimum: 3, maximum: 30}

  validates :password, format: { with: /\A(?=.*[A-Z])(?=.*[0-9]).{4,}\z/}

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def self.top(n)
    User.all.sort_by{ |b| -(b.ratings.count||0) }.first(n)
  end

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    favorite :style
  end

  def favorite_brewery
    favorite :brewery
  end

  def favorite(category)
    return nil if ratings.empty?

    rated = ratings.map{ |r| r.beer.send(category) }.uniq
    rated.sort_by { |item| -rating_of(category, item) }.first
  end

  def rating_of(category, item)
    ratings_of = ratings.select{ |r| r.beer.send(category)==item }
    ratings_of.map(&:score).inject(&:+) / ratings_of.count.to_f
  end
end
