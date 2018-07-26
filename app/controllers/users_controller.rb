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
      flash[:message] = "You are already logged in."
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
      flash[:warning] = "That email or username is not valid. Choose something else."
      redirect "/signup"
    else
      @user = User.new(username: params[:username], email: params[:email], password: params[:password])
      @user.initial_folders
      @user.save!

      session[:user_id] = @user.id

      flash[:success] = "You have successfully registered!"
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

        flash[:success] = "You have successfully logged in!"
        redirect "/#{@user.slug}"

      else
        flash[:warning] = "Could not verify the password or username. Please check and try again."
        redirect "/login"
      end

    else
      flash[:login] = "Could not log you in. Please check your username and password and try again."
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

      flash[:success] = "You have successfully logged out."
      redirect "/"
    else
      flash[:login] = "You are not logged in. Please Log in or Register."
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
      flash[:login] = "You are not logged in. Please Log in or Register."
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

      flash[:success] = "Your information has been successfully updated."
      redirect "/#{@user.slug}/user_info"

    else
      flash[:login] = "You are not logged in. Please Log in or Register."
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
    else
      flash[:login] = "You are not logged in. Please Log in or Register."
      redirect "/login"
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
      flash[:login] = "You are not logged in. Please Log in or Register."
      redirect "/login"
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

        flas[:success] = "Your account was successfully deleted."
        redirect "/"
      else
        flas[:warning] = "Could not delete account."
        redirect "/#{@user.slug}"
      end

    else
      flash[:login] = "You are not logged in. Please Log in or Register."
      redirect "/login"
    end
  end

end
