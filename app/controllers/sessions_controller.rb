
class SessionsController < ApplicationController
  def new
  end

  def create_oauth
    userdata = env["omniauth.auth"]

    user = User.find_by github_uid: userdata.uid


    if user.nil?
      new_user = User.new username: userdata.info.nickname, github_uid:userdata.uid
      new_user.using_github = true
      new_user.save!
      session[:user_id] = new_user.id
      redirect_to user_path(new_user), notice: "Welcome, #{new_user.username}"
    else
      if user.banned
        redirect_to :back, notice: "Your account is frozen, please contact admin"
       else
        session[:user_id] = user.id
        redirect_to user_path(user), notice: "Welcome back!"
      end
    end
  end

  def create
    user = User.find_by username: params[:username]

    if user && user.github_uid.nil? && user.authenticate(params[:password])
      if user.banned
        redirect_to :back, notice: "Your account is frozen, please contact admin"
      else
        session[:user_id] = user.id
        redirect_to user_path(user), notice: "Welcome back!"
      end
    else
      redirect_to :back, notice: "Username and/or password mismatch"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end