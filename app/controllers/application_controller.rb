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

    ####################################
    # Generates a Simple Flash Message #
    ####################################
    def generate_flash(message)
        flash[:success_message] = message
    end


    ######  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  ######
    ##  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  ####
    ##                                                                ##
    ##                  Some Repetitiveness here                      ##
    ##             Could not figure out how to do this                ##
    ##       Might need to use something like metaprogramming         ##
    ##                                                                ##
    ##  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  ####
    ######  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  ######


    ##########################
    # ** CATEGORY HELPERS ** #
    ##########################

    ########################################################
    # Adds selected items from the drop down to the category #
    ########################################################
    def add_existing_items_to_the_category(item_ids, instance_variable)
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
    def add_the_newly_created_item_to_the_category(item_name, item_description, item_cost, instance_variable)
      if !item_name.empty?
        new_item = Item.create(name: item_name, description: item_description, cost: item_cost) if item_name != ""
        instance_variable.items << new_item if item_name != ""
        current_user.items << new_item  if item_name != ""
      end
    end


    ########################
    # ** FOLDER HELPERS ** #
    ########################

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
    def add_the_newly_created_item_to_the_folder(item_name, item_description, item_cost, instance_variable)
      if item_name != ""
        new_item = Item.create(name: item_name, description: item_description, cost: item_cost)
        instance_variable.items << new_item
        current_user.items << new_item
      end
    end


    ########################
    # ** ITEM HELPERS ** #
    ########################


    #################################################################
    # Adds the item to the folders selected from the drop down menu #
    #################################################################
    def add_the_item_to_existing_folders(folder_ids, instance_variable)
      if folder_ids
        yield if block_given?
        folder_ids.each do |folder_id|
          folder = current_user.folders.find_by_id(folder_id)
          folder.items << instance_variable
          current_user.items << instance_variable
        end
      end
    end

    #############################################
    # Adds the item to the newly created folder #
    # if the new folder name field is not empty #
    #############################################
    def add_the_item_to_the_newly_created_folder(new_folder_name, instance_variable)

      if new_folder_name != ""
        folder_name_exists = !Folder.find_by_folder_name(new_folder_name, current_user.id).empty?
        if !folder_name_exists
          new_folder = Folder.create(name: new_folder_name)
          new_folder.items << instance_variable
          current_user.folders << new_folder
        end
      end
    end

    ###############################################
    # Adds the item to the newly created category #
    # if the new category name field is not empty #
    ###############################################
    def add_the_item_to_the_newly_created_category(new_category_name, instance_variable)

      if new_category_name != ""
        category_name_exists = !current_user.find_by_category_name(new_category_name).empty?
        if !category_name_exists
          new_category = Category.create(name: new_category_name)
          new_category.items << instance_variable
          current_user.categories << new_category
        end
      end
    end

  end #helpers
end
