require 'rails_helper'

include Helpers

describe "User" do
  let!(:user) { FactoryGirl.create :user }

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  it "shows favorite beer style and brewery" do
    create_brewery_beers_and_ratings

    sign_in(username:"Pekka", password:"Foobar1")

    expect(page).to have_content "Favorite style: #{user.favorite_style}"
    expect(page).to have_content "Favorite brewery: #{user.favorite_brewery.name}"
  end
end

def create_brewery_beers_and_ratings
  brewery = FactoryGirl.create :brewery, name:"Koff"
  beer1 = FactoryGirl.create :beer, name:"iso 3", style:"IPA", brewery:brewery
  brewery2 = FactoryGirl.create :brewery, name:"Hartwall"
  beer2 = FactoryGirl.create :beer, name:"jokuolut", brewery:brewery2
  FactoryGirl.create :rating, beer:beer1, user:user, score:25
  FactoryGirl.create :rating, beer:beer2, user:user, score:10
end