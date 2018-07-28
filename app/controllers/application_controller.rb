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

    #############
    #   PROCS   #
    #############

        folder_proc = proc { |folder_id| current_user.folders.find_by_id(folder_id) }
        category_proc = proc { |category_id| current_user.categories.find_by_id(category_id) }


    ###################################
    # ** FOLDER / CATEGORY HELPERS ** #
    ###################################


    ##########################################################
    # Adds selected EXISTING items to the folder or category #
    ##########################################################
    def add_existing_items_to_folder_category(item_ids, fc_variable)
      if item_ids
        yield if block_given?
        item_ids.each do |item_id|
          fc_variable.items << current_user.items.find_by_id(item_id)
        end
      end
    end

    ######################
    # ** ITEM HELPERS ** #
    ######################

    ############################################################
    # Adds the item to selected EXISTING folders or categories #
    ############################################################

    def add_to_selected_folder_category(fc_ids, fc_selected, proc_name)
      if fc_ids
        yield if block_given?

        fc_ids.each do |fc_id|

          folder_category = proc_name.call(fc_id)

          if !folder_category.nil?
            folder_category.items << instance_variable
            current_user.items << instance_variable
          end
        end
      end
    end


    inserter(new_folder.items, item) # new_folder << itme
    inserted(new_category.items, item)


    ############ IN DEVELOPMENT ###############
    #******************* # ********************#

    new_item_to_folder = proc { |new_item, @folder| @folder.items << new_item }
    new_item_to_category = proc { |new_item, @category| @category.items << new_item}
    item_to_new_folder = proc { |new_folder, item| new_folder.items << item}
    item_to_new_category = proc { |new_category, item| new_category.items << item }

    def add_item_to_folder_category(ifc_ids:, new_object:, proc_find:, proc_add_item:)
      if ifc_ids
        yield if block_given?
        ifc_ids.each do |ifc_id|
          selected_ifc = proc_find.call(ifc_id)
          if !itm_fld_ctg.nil?
            proc_add_item.call(new_object, selected_ifc)
          end
        end
      end
    end

            #new_object.items << selected_ifc       |  a << b
            #new_category.items << selected_ifc     |  a << b
            #selected_ifc.items << new_item         |  b << a
            #selected_ifc.items << new_item         |  b << a


    ############################################

    ########################################################
    # Adds the new item to the folder and user's item list #
    # if the new item name field is not empty              #
    ########################################################
    def add_the_newly_created_item(name:, description:, cost:, instance_variable)
      if !item_name.blank?
        new_item = Item.create(name: name, description: description, cost: cost)
        instance_variable.items << new_item
        current_user.items << new_item
      end
    end


    ###############################################
    # Adds the item to the newly created category #
    # if the new category name field is not empty #
    ###############################################
    def add_the_item_to_new_folder_category(new_fc_name, item, klass) { current_user.categories }

      if !new_fc_name.blank?
        folder_category = !klass.find_by_name(new_fc_name, current_user.id).blank?
        if !folder_category
          new_folder_category = klass.create(name: new_fc_name)
          new_folder_category.items << item
          yield << new_folder_category
        end
      end
    end

  end #helpers
end
