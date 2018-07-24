require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    register Sinatra::Flash
    enable :sessions unless test?
    set :session_secret, "secret"
  end

  #######################
  # Retrieves Home page #
  #######################

  get "/" do
    if !logged_in?
      erb :welcome_index
    else
      redirect "/#{current_user.slug}"
    end
  end


  helpers do

    #################################
    # Checks if a user is logged in #
    #################################
    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def logged_in?
      !!current_user
    end
  end #helpers

end
