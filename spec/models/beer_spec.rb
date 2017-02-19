require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "is saved if it has name and style" do
    style = Style.create name:"Lager"
    beer = Beer.create name:"Kalja", style:style
    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without name" do
    style = Style.create name:"Lager"
    beer = Beer.create name:"", style:style
    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without style" do
    beer = Beer.create name:"Karjala", style:nil
    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
