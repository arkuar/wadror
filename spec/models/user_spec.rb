require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  it "is not saved when password too short" do
    user = User.create username:"Pekka", password:"a", password_confirmation:"a"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved when password is invalid" do
    user = User.create username:"Pekka", password:"Aapelikkaapeli", password_confirmation:"Aapelikaapeli"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(user, 10)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(user, 10, 20, 15, 7, 9)
      best = create_beer_with_rating(user, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){FactoryGirl.create(:user)}

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(user, 10)

      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the one with highest average rating if several rated" do
      create_beers_with_ratings(user, 10, 5, 15)
      best = FactoryGirl.create(:beer, style:"Weizen")
      FactoryGirl.create(:rating, score:40, beer:best, user:user)

      expect(user.favorite_style).to eq(best.style)
    end
  end

  describe "favorite brewery" do
    let(:user){FactoryGirl.create(:user)}

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "is the only rated if only one rating" do
      beer = create_beer_with_rating(user, 5)

      expect(user.favorite_brewery).to eq(beer.brewery)
    end

    it "is the one with highest averate rating if several rated" do
      create_brewery_with_beers(user, 5, 10, 5)
      best = create_custom_brewery_with_beer(user, 40)

      expect(user.favorite_brewery).to eq(best)
    end
  end
end

def create_beers_with_ratings(user, *scores)
  scores.each do |score|
    create_beer_with_rating(user, score)
  end
end

def create_beer_with_rating(user, score)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_brewery_with_beer(user, score)
  brewery = FactoryGirl.create(:brewery)
  beer = FactoryGirl.create(:beer, brewery:brewery)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  brewery
end

def create_custom_brewery_with_beer(user, score)
  brewery = FactoryGirl.create(:brewery, name:"Koff")
  beer = FactoryGirl.create(:beer, brewery:brewery)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  brewery
end

def create_brewery_with_beers(user, *scores)
  brewery = FactoryGirl.create(:brewery)
  scores.each do |score|
    beer = create_beer_with_rating(user, score)
    beer.brewery = brewery
    beer.save
  end
end
