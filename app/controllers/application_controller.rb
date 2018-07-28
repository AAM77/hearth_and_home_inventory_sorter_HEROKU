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
    ##             Could not figure out how to reduce this            ##
    ##                                                                ##
    ##  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  ####
    ######  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  #  ######

    #############
    #   PROCS   #
    #############

    #--------------------------------------------------------------#
    #  ---  FOR USE WITH METHOD: add_item_to_folder_category  ---  #
    #--------------------------------------------------------------#

    #------------#
    # FIND PROCS #
    #------------#

    #find selected folder
    def find_folder_proc
      proc { |folder_id| current_user.folders.find_by_id(folder_id) }
    end

    #find selected category
    def find_category_proc
      proc { |category_id| current_user.categories.find_by_id(category_id) }
    end

    #find selected item
    def find_item_proc
      proc { |item_id| current_user.items.find_by_id(item_id) }
    end

    #-----------#
    # ADD PROCS #
    #-----------#

    # selected_folder << new_item
    def new_item_to_folder_proc
      proc { |new_item, selected_folder| selected_folder.items << new_item }
    end

    # selected_category << new_item
    def new_item_to_category_proc
      proc { |new_item, selected_category| selected_category.items << new_item }
    end

    # new_folder << selected_item
    def item_to_new_folder_proc
      proc { |ncew_folder, selected_item| new_folder.items << item }
    end

    # new_category << selected_item
    def item_to_new_category_proc
      proc { |new_category, selected_item| new_category.items << item }
    end



    ##########################################
    # ** ITEM / FOLDER / CATEGORY HELPERS ** #
    ##########################################


    ############################################################
    # Adds the item to selected EXISTING folders or categories #
    ############################################################

    def add_selected_item_folder_category(ifc_ids:, new_object:, find_proc:, add_item_proc:)
      if ifc_ids
        yield if block_given?

        ifc_ids.each do |ifc_id|
          selected_ifc = find_proc.call(ifc_id)

          if !selected_ifc.nil?
            add_item_proc.call(new_object, selected_ifc)
          end
        end
      end
    end

    ########################################################
    # Adds the new item to the folder and user's item list #
    # if the new item name field is not empty              #
    ########################################################

    def add_the_newly_created_item(name:, description:, cost:, new_folder_category:)
      if !item_name.blank?
        new_item = Item.create(name: name, description: description, cost: cost)
        new_folder_category.items << new_item
        current_user.items << new_item
      end
    end


    ###############################################
    # Adds the item to the newly created category #
    # if the new category name field is not empty #
    ###############################################

    def add_item_to_new_folder_category(new_fc_name:, item:, klass:)

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
end #class
