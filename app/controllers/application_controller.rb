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
      if !item_name.empty?
        new_item = Item.create(name: item_name, description: item_description, cost: item_cost)
        instance_variable.items << new_item
        current_user.items << new_item
      end
    end


    ########################
    # ** ITEM HELPERS ** #
    ########################

    ########################################################
    # Adds the new item to the folder and user's item list #
    # if the new item name field is not empty              #
    ########################################################
    def add_the_newly_created_item(item_name, item_description, item_cost, instance_variable)
      if !item_name.empty?
        new_item = Item.create(name: item_name, description: item_description, cost: item_cost)
        instance_variable.items << new_item
        current_user.items << new_item
        instance_variable.save
        current_user.save
      end
    end


    #################################################################
    # Adds the item to the folders selected from the drop down menu #
    #################################################################

    folder_proc = proc { |user, folder_id| user.folders.find_by_id(folder_id) }
    category_proc = proc { |user, category_id| user.categories.find_by_id(category_id) }

    def add_to_existing_folder_category(category_ids, instance_variable)
      if category_ids
        yield if block_given?
        category_ids.each do |category_id|
          category = current_user.categorys.find_by_id(category_id)
          category.items << instance_variable
          current_user.items << instance_variable
        end
      end
    end

    def call_folder_category(proc_name, user)
      snooze = Item.create(name: "sleep", description: "zzzzz zzzzz zzzz", cost: 3434253)
      @object_ids.each do |object_id|
        section = proc_name.call(user, object_id)
        if !section.nil?
          section.items << snooze
        end
      end
    end

    sarah.categories.each do |category|
      category.items.each do |item|
        if item.name == "sleep"
          puts "#{category.name} <- :: -> #{item.name}"
        end
      end
    end

    #
    #
    #

    ########

    #
    #
    #


    def add_the_item_to_existing_sections(object_ids, object_var, proc_name)
      if object_ids
        yield if block_given?
        object_ids.each do |object_id|
          section = proc_name.call
          current_user.items << instance_variable
          section.items << instance_variable
        end
      end
    end


    def add_the_item_to_existing_sections(section_ids, instance_variable, sections)
      if section_ids
        yield if block_given?
        section_ids.each do |section_id|
          section = current_user.sections.find_by_id(folder_id)
          section.items << instance_variable
          current_user.items << instance_variable
          section.save
          current_user.save
        end
      end
    end

    def testing(user, sections)
      user.sections.each {|section| puts section.name}
    end


    ####################################################################
    # Adds the item to the categories selected from the drop down menu #
    ####################################################################
    def add_the_item_to_existing_categories(category_ids, instance_variable)
      if category_ids
        yield if block_given?
        category_ids.each do |category_id|
          category = current_user.categorys.find_by_id(category_id)
          category.items << instance_variable
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
        category_name_exists = !Category.find_by_category_name(new_category_name, current_user.id).empty?
        if !category_name_exists
          new_category = Category.create(name: new_category_name)
          new_category.items << instance_variable
          current_user.categories << new_category
        end
      end
    end

  end #helpers
end
