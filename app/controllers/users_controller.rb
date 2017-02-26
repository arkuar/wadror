class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :toggle_ban]
  before_action :ensure_that_signed_in, except: [:index, :show, :new, :create]
  before_action :ensure_that_admin, only: :toggle_ban

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  def toggle_ban
    user = User.find(params[:id])
    user.update_attribute :banned, (not user.banned)

    new_status = user.banned ? 'frozen' : 'unfrozen'

    redirect_to :back, notice: "User has been #{new_status}"
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user == current_user
      respond_to do |format|
        if user_params[:username].nil? and @user == current_user and @user.update(user_params)
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
      @user.destroy if @user == current_user
      session[:user_id] = nil
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end
end
