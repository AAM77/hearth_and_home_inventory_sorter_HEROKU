require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    register Sinatra::Flash
    enable :sessions unless test?
    set :session_secret, "secret"
  end


  ###################################################
  # FOR ALL ROUTES: If the user is not logged in,   #
  # it redirects to the home, signup, or login page #
  ###################################################

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

    ##############################################
    # Retrieves current user if one is logged in #
    ##############################################
    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    ###################################################################
    # Checks to see if logged in if a session exists for current user #
    ###################################################################
    def logged_in?
      !!current_user
    end

    ########################################################
    # Adds selected items from the drop down to the folder #
    ########################################################
    def add_existing_items_to_the_folder(item_ids, instance_variable)
      if item_ids
        yield if block_given?
        item_ids.each do |item_id|
          instance_variable.items << current_user.items.find_by_id(item_id)
        end
      end
    end
  end #helpers

  ########################################################
  # Adds the new item to the folder and user's item list #
  # if the new item name field is not empty              #
  ########################################################
  def add_the_newly_created_item_to_the_folder(item_name, instance_variable)
    if !item_name.empty?
      new_item = Item.create(name: item_name)
      instance_variable.items << new_item
      current_user.items << new_item
    end
  end

end
