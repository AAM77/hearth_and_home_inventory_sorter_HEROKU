class UsersController < ApplicationController

  ###################################################
  # FOR ALL ROUTES: If the user is not logged in,   #
  # it redirects to the home, signup, or login page #
  ###################################################



  ##########################################
  # Retrieves the Signup/Registration Page #
  ##########################################
  get "/signup" do
    if logged_in?
      redirect "/#{current_user.slug}"
    else
      erb :"users/create_user"
    end
  end

  ###########################################
  # Registers a new account                 #
  # does not if the username or email exist #
  ###########################################
  post "/signup" do
    @user = User.find_by_username(params[:username])
    @email = User.find_by_email(params[:email])

    if @user || @email
      redirect "/signup"
    else
      @user = User.new(username: params[:username], email: params[:email], password: params[:password])
      @user.initial_folders
      @user.save!

      session[:user_id] = @user.id

      redirect "/folders"
    end
  end

  ############################
  # Retrieves the Login Page #
  ############################

  get "/login" do
    if logged_in?
      @user = current_user
      redirect :"/#{@user.slug}"
    else
      erb :"users/login_user"
    end
  end

  ##################################################
  # If the credentials exist and match,            #
  # it establishes a session and logs in the user  #
  ##################################################
  post "/login" do
    if !logged_in?
      @user = User.find_by_username(params[:username])

      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect "/#{@user.slug}"
      else
        redirect "/signup"
      end

    else
      redirect "/login"
    end
  end

  #############################################
  # Logs out the User by clearing the session #
  # & Returns to the Home Page                #
  #############################################
  get "/logout" do
    if logged_in?

      session.clear
      redirect "/"
    else
      redirect "/login"
    end
  end


  ##########################
  # Displays the edit form #
  ##########################
  get "/:slug/edit" do
    if logged_in?
      erb :"users/edit_user"
    else
      redirect "/login"
    end
  end

  #################################################
  # Changes the User's Information if any Entered #
  #################################################
  patch "/:slug/edit" do

    if logged_in?
      @user = current_user

      @user.first_name = params[:first_name] if params[:first_name] != ""
      @user.last_name = params[:last_name] if params[:last_name] != ""
      @user.telephone = params[:telephone] if params[:telephone] != ""
      @user.email = params[:email] if params[:email] != ""

      @user.save!(validate: false)
      redirect "/#{@user.slug}/user_info"

    else
      redirect "/login"
    end
  end

  ##################################
  # Retrieves the user's info page #
  ##################################

  get "/:slug/user_info" do
    if logged_in?
      @user = current_user
      erb :"users/user_info"
    end
  end


  ##################################
  # Retrieves the User's Home Page #
  ##################################
  get "/:slug" do
    if logged_in?
      @user = current_user
      erb :"users/show_user"
    else
      redirect "/signup"
    end
  end


  ##########################################
  # Permanently Deletes the User's Account #
  ##########################################
  delete "/:slug/delete" do
    if logged_in?
      @user = User.find_by_slug(params[:slug])
      if @user.id == current_user.id
        @user.destroy
        redirect "/"
      else
        redirect "/#{@user.slug}"
      end

    else
      redirect "/login"
    end
  end

end
