class BeerClub < ActiveRecord::Base
  has_many :memberships
  has_many :members, through: :memberships, source: :user

  def to_s
    "#{self.name} (#{self.founded} #{self.city}"
  end
end
