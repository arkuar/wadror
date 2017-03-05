
class RatingsController < ApplicationController
  def index
    # Hakee tiedot kymmenen minuutin välein.
    @ratings = Rails.cache.fetch("ratings_all", expires_in: 10.minutes) { Rating.includes(:beer, :user).all }
    @top_raters = Rails.cache.fetch("top_raters", expires_in: 10.minutes) { User.top 3 }
    @top_breweries = Rails.cache.fetch("top_breweries", expires_in: 10.minutes) { Brewery.top 3 }
    @top_beers = Rails.cache.fetch("top_beers", expires_in: 10.minutes) { Beer.top 3 }
    @top_styles = Rails.cache.fetch("top_styles", expires_in: 10.minutes) { Style.top 3 }
    @recent_ratings = Rails.cache.fetch("recent_ratings") { Rating.recent }
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    if current_user.nil?
      redirect_to signin_path, notice: 'You need to be signed in'
    elsif @rating.save
      current_user.ratings << @rating
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end
end