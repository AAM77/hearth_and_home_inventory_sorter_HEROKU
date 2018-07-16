class UsersController < ApplicationController

  get "/signup" do
    erb :"users/create_user"
  end

  post "/signup" do
    @user = User.new(username: params[:username], email: params[:email], password: params[:password])
    @user.initial_folders
    if @user.save
      session[:user_id] = @user.id
      redirect "/folders"
    else
      redirect "/signup"
    end
  end

  get "/login" do
    if !logged_in?
      erb :"users/login_user"
    else
      redirect :"/users/#{current_user.slug}"
    end
  end

  post "/login" do

    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "users/#{@user.slug}"
    else
      redirect "/signup"
    end
  end

  get "/logout" do
    if !logged_in?
      redirect "/"
    else
      session.clear
      redirect "/login"
    end
  end

  get "/users/:slug" do
    @folders = current_user.folders
    erb :"folders/folder_index"
  end


end
