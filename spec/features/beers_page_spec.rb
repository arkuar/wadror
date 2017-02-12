require 'rails_helper'
include Helpers

describe "Beer" do
  let!(:user) { FactoryGirl.create :user }
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "is added when the name is valid" do
    visit new_beer_path
    fill_in('beer[name]', with: 'Olut')
    select('Lager', from: 'beer[style]')
    select('Koff', from: 'beer[brewery_id]')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end

  it "is not added if name is invalid" do
    visit new_beer_path
    click_button "Create Beer"

    expect(current_path).to eq(beers_path)
    expect(page).to have_content "Name can't be blank"
    expect(Beer.count).to eq(0)
  end
end
