class Membership < ActiveRecord::Base
  belongs_to :beer_club
  belongs_to :user

  validates :beer_club_id, uniqueness: { scope: [:user_id] }
end
