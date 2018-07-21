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
      redirect :"/#{@user.slug}"
    else
      erb :"users/login_user"
    end
  end

  post "/login" do

    @user = User.find_by_username(params[:username])

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/#{@user.slug}"
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

  get "/:slug/edit" do
    if logged_in?
      erb :"users/edit_user"
    else
      redirect "/login"
    end
  end

  patch "/:slug/edit" do
    if logged_in?
      @user = current_user
      @user.first_name = params[:first_name]
      @user.last_name = params[:last_name]
      @user.telephone = params[:telephone]
      @user.email = params[:email]

      #@user.password:
      if params[:old_password] == @user.password && params[:new_password] == params[:confirm_password]
        @user.password = params[:new_password]
      end

      if @user.save
        redirect "/#{@user.slug}/user_info"
      else
        redirect "/#{@user.slug}/edit"
      end

    else
      redirect "/login"
    end
  end

  get "/:slug/account_details" do
    if logged_in?
      @user = current_user
      erb :"users/user_info"
    end
  end

  get "/:slug" do
    if logged_in?
      @user = current_user
      erb :"users/show_user"
    else
      redirect "/signup"
    end
  end

  delete "/:slug/delete" do
    if logged_in?
      @user = current_user
      if @user.user_id == current_user.id
        @user.delete
        redirect "/"
      else
        redirect "/#{@user.slug}"
      end

    else
      redirect "/login"
    end
  end



end
