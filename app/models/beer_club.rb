class BeerClub < ActiveRecord::Base
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user

  has_many :confirmed_memberships, -> { where confirmed: true}, class_name: "Membership"
  has_many :unconfirmed_memberships, -> { where confirmed: [nil, false] }, class_name: "Membership"

  def member(user)
    !(self.confirmed_memberships.where user_id:user.id).empty?
  end

  def to_s
    "#{self.name} (#{self.founded} #{self.city})"
  end
end
