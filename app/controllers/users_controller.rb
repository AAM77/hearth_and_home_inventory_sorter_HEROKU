class UsersController < ApplicationController


  get "/signup" do
    erb :"users/create_user"
  end

  post "/signup" do
    @user = User.find_by_username(params[:username])
    @email = User.find_by_email(params[:email])

    if @user || @email
      redirect "/signup"
    else
      @user = User.new(username: params[:username], email: params[:email], password: params[:password])
      @user.initial_folders
      @user.save
      session[:user_id] = @user.id
      redirect "/folders"
    end
  end

  get "/login" do
    if logged_in?
      @user = current_user
      redirect :"#{@user.slug}"
    else
      erb :"users/login_user"
    end
  end

  post "/login" do

    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "#{@user.slug}"
    else
      redirect "/signup"
    end
  end

  get "/logout" do
    if logged_in?
      session.clear
      redirect "/login"
    else
      redirect "/"
    end
  end

  get "/:slug" do
    @user = current_user
    erb :"users/show_user"
  end

end
