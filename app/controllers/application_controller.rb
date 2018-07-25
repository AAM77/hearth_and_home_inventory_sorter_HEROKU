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


    ######################
    # ** ITEM HELPERS ** #
    ######################

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


    ####  #  #  #  #  # #  #  #  #  #  #  # #  #  #  #  #  #  #  #  ###
    ##  #  #  #  #  #  # #  #  #  #  #  #  # #  #  #  #  #  #  #  #  ##
    ##               Some Repetitiveness here                        ##
    ## Could not figure out how to do this without metaprogramming   ##
    ##  #  #  #  #  #  # #  #  #  #  #  #  # #  #  #  #  #  #  #  #  ##
    ####  #  #  #  #  # #  #  #  #  #  #  # #  #  #  #  #  #  #  #  ###


    ########################
    # ** FOLDER HELPERS ** #
    ########################


    #################################################################
    # Adds the item to the folders selected from the drop down menu #
    #################################################################
    def add_existing_items_to_the_folder(folder_ids, instance_variable)
      if folder_ids
        yield if block_given?
        folder_ids.each do |folder_id|
          folder = currect_user.folders.find_by_id(folder_id)
          folder.items << instance_variable
          current_user.items << instance_variable
        end
      end
    end

    ########################################################
    # Adds the item to the newly created folder            #
    # if the new folder name field is not empty            #
    ########################################################
    def add_the_newly_created_item_to_the_folder(folder_name, instance_variable)
      folder_exists = !folder_name.empty?

      if folder_exists
        new_folder = Folder.create(name: folder_name)
        new_folder.items << new_item
        current_user.folders << new_folder
      end
    end



    ##########################
    # ** CATEGORY HELPERS ** #
    ##########################

    #####################################################################
    # Adds the item to the categoriess selected from the drop down menu #
    #####################################################################
    def add_existing_items_to_the_category(category_ids, instance_variable)
      if category_ids
        yield if block_given?
        category_ids.each do |category_id|
          category = currect_user.categories.find_by_id(category_id)
          category.items << instance_variable
          current_user.items << instance_variable
        end
      end
    end

    ################################################
    # Adds the item to the newly created category  #
    # if the new category name field is not empty  #
    ################################################
    def add_the_newly_created_item_to_the_category(category_name, instance_variable)
      category_exists = !category_name.empty?

      if category_exists
        new_categroy = Category.create(name: category_name)
        new_category.items << new_item
        current_user.categories << new_categories
      end
    end

  end #helpers
end
