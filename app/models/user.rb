class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
            length: {minimum: 3, maximum: 30}

  validates :password, format: { with: /\A(?=.*[A-Z])(?=.*[0-9]).{4,}\z/}

  has_many :ratings, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    ratingsum = {}
    amount = {}
    ratings.all.each do |rating|
      style = find_style(rating.beer_id)

      if ratingsum[style].nil?
        ratingsum[style] = 0
        amount[style] = 0
      end
        ratingsum[style] += rating.score
        amount[style] += 1
    end

    average = calculate_average(ratingsum, amount)
    average.max_by{ |style, score| score}[0]
  end

  def calculate_average(ratingsum, amount)
    average = {}
    
    ratingsum.each do |style, score|
      average[style] = score / amount[style]
    end
    average
  end


  def find_style(beer_id)
    beer = Beer.find_by id:beer_id
    beer.style
  end

  def favorite_brewery
    return nil if ratings.empty?
    ratingsum = {}
    amount = {}
    ratings.all.each do |rating|
      brewery = find_brewery(rating.beer_id)

      if ratingsum[brewery].nil?
        ratingsum[brewery] = 0
        amount[brewery] = 0
      end
      ratingsum[brewery] += rating.score
      amount[brewery] += 1
    end

    average = calculate_average(ratingsum, amount)
    average.max_by{ |brewery, score| score}[0]
  end

  def find_brewery(beer_id)
    beer = Beer.find_by id:beer_id
    beer.brewery
  end
end
