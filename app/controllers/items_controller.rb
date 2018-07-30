class ItemsController < ApplicationController

  ###################################################
  # FOR ALL ROUTES: If the user is not logged in,   #
  # it redirects to the home, signup, or login page #
  ###################################################


  #################################
  # Retrieves the item index page #
  #################################

  get "/:slug/items" do
    if logged_in?
      @folders = current_user.folders.sort { |a,b| a.name.downcase <=> b.name.downcase }
      @items = current_user.items.sort { |a,b| a.name.downcase <=> b.name.downcase }
      erb :"items/item_index"
    else
      flash[:login] = "You are not logged in. Please Log in or Register."
      redirect "/login"
    end
  end

  ####################################
  # Retrieves the item creation page #
  ####################################

  get "/:slug/items/new" do
    if logged_in?
      @folders = current_user.folders.sort { |a,b| a.name.downcase <=> b.name.downcase }
      @categories = current_user.categories.sort { |a,b| a.name.downcase <=> b.name.downcase }
      erb :"items/create_item"
    else
      flash[:login] = "You are not logged in. Please Log in or Register."
      redirect "/login"
    end
  end


  ###############################################
  # Uses the information to create a new item   #
  # And assigns it the respective details       #
  # And associations                            #
  ###############################################

  post "/:slug/items/new" do
    if logged_in?
      if params[:item][:name].empty?
        flash[:warning] = "You must enter an item name!"
        redirect "/#{current_user.slug}/items/new"
      else

        #procs
        find_folder = find_folder_proc
        find_category = find_category_proc
        item_to_folder = new_item_to_folder_proc
        item_to_category = new_item_to_category_proc
        #binding.pry

        # create & save the item
        @item = Item.create(name: params[:item][:name], description: params[:item][:description], cost: params[:item][:cost])

        # add to selected folders
        add_selected_item_folder_category(ifc_ids: params[:item][:folder_ids], new_object: @item, find_proc: find_folder, add_item_proc: item_to_folder)

        # add to new folder
        add_item_to_new_folder_category(new_fc_name: params[:folder][:name], item: @item, klass: Folder) { current_user.folders }

        # add selected categories
        add_selected_item_folder_category(ifc_ids: params[:item][:category_ids], new_object: @item, find_proc: find_category, add_item_proc: item_to_category)

        # add to new category
        add_item_to_new_folder_category(new_fc_name: params[:category][:name], item: @item, klass: Category) { current_user.categories }

        current_user.items << @item

        flash[:success] = "Successfully created the item: #{@item.name}"
        redirect "/#{current_user.slug}/items"
      end

    else
      flash[:login] = "You are not logged in. Please Log in or Register."
      redirect "/login"
    end
  end

  #################################
  # Retrieves the item edit page #
  #################################

  get "/:user_slug/items/:item_slug/:item_id/edit" do
    if logged_in?
      @item = current_user.items.find_by_id(params[:item_id])
      @folders = current_user.folders.sort { |a,b| a.name.downcase <=> b.name.downcase }
      @categories = current_user.categories.sort { |a,b| a.name.downcase <=> b.name.downcase }

      erb :"items/edit_item"

    else
      flash[:login] = "You are not logged in. Please Log in or Register."
      redirect "/login"
    end
  end


  ########################################
  # Edits the item's details and folders #
  ########################################

  patch "/:user_slug/items/:item_slug/:item_id/edit" do
    if logged_in?

      @item = current_user.items.find_by_id(params[:item_id])
      @item.name = params[:item][:name] if !params[:item][:name].blank?
      @item.cost = params[:item][:cost] if !params[:item][:cost].blank?
      @item.description = params[:item][:description] if !params[:item][:description].blank?

      @item.save

      #procs
      find_folder = find_folder_proc
      find_category = find_category_proc
      item_to_folder = new_item_to_folder_proc
      item_to_category = new_item_to_category_proc
      #binding.pry

      # add to selected folders
      add_selected_item_folder_category(ifc_ids: params[:item][:folder_ids], new_object: @item, find_proc: find_folder, add_item_proc: item_to_folder) { @item.folders.clear }

      # add to new folder
      add_item_to_new_folder_category(new_fc_name: params[:folder][:name], item: @item, klass: Folder) { current_user.folders }

      # add selected categories
      add_selected_item_folder_category(ifc_ids: params[:item][:category_ids], new_object: @item, find_proc: find_category, add_item_proc: item_to_category) { @item.categories.clear }

      # add to new category
      add_item_to_new_folder_category(new_fc_name: params[:category][:name], item: @item, klass: Category) { current_user.categories }



      flash[:success] = "Successfully updated the details for item: [#{@item.name}]."
      redirect "/#{current_user.slug}/items/#{@item.slug}/#{@item.id}"
    else
      flash[:login] = "You are not logged in. Please Log in or Register."
      redirect "/login"
    end
  end

  #############################################
  # Deletes the item for a user (all folders) #
  #############################################
  delete "/:user_slug/items/:item_slug/:item_id/delete" do
    if logged_in?
      @item = Item.find_by_item_slug(params[:item_slug], params[:item_id].to_i, current_user.id)
      @item.destroy

      flash[:warning] = "You have deleted [ #{@item.name} ] from everywhere on your account !! It no longer exists."
      redirect "/#{current_user.slug}/items"
    else
      flash[:login] = "You are not logged in. Please Log in or Register."
      redirect "/login"
    end
  end

  ###########################################
  # Deletes the item from a specific folder #
  ###########################################
  delete "/:user_slug/folders/:folder_slug/:folder_id/items/:item_slug/:item_id/delete" do
    if logged_in?
      @item = current_user.items.find_by_id(params[:item_id])
      @folder = current_user.folders.find_by_id(params[:folder_id])
      #@item_name = @item.name

      if @item && @folder
        @item.folders.delete(Folder.find_by_id(params[:folder_id]))
        @folder.items.delete(Item.find_by_id(params[:item_id]))
      end

      flash[:success] = "Successfully deleted the item from folder [#{@folder.name}]. You can still find it in your items section."
      redirect "/#{current_user.slug}/folders/#{@folder.slug}"

    else
      flash[:login] = "You are not logged in. Please Log in or Register."
      redirect "/login"
    end
  end

  ## Not DRY !!!
  ## Do something about this

  ###########################################
  # Deletes the item from a specific category #
  ###########################################
  delete "/:user_slug/categories/:category_slug/:category_id/items/:item_slug/:item_id/delete" do
    if logged_in?
      @item = current_user.items.find_by_id(params[:item_id])
      @category = current_user.categories.find_by_id(params[:category_id])
      #@item_name = @item.name

      if @item && @category
        @item.categories.delete(Category.find_by_id(params[:category_id]))
        @category.items.delete(Item.find_by_id(params[:item_id]))
      end

      flash[:success] = "Successfully deleted the item from category [#{@category.name}]. You can still find it in your items section."
      redirect "/#{current_user.slug}/categories/#{@category.slug}"

    else
      flash[:login] = "You are not logged in. Please Log in or Register."
      redirect "/login"
    end
  end

  #######################################
  # Retrieves the item's show/info page #
  #######################################

  get "/:user_slug/items/:item_slug/:item_id" do
    if logged_in?
      @item = Item.find_by_item_slug(params[:item_slug], params[:item_id].to_i, current_user.id)
      erb :"items/show_item"
    else
      flash[:login] = "You are not logged in. Please Log in or Register."
      redirect "/login"
    end
  end


end
