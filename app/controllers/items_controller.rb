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
        @item = Item.create(name: params[:item][:name], description: params[:item][:description], cost: params[:item][:cost])

        add_the_item_to_existing_folders(params[:item][:folder_ids], @item)
        add_the_item_to_the_newly_created_folder(params[:folder][:name], @item)

        @item.save

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
      @item.name = params[:item][:name] if params[:item][:name] != ""
      @item.cost = params[:item][:cost] if params[:item][:cost] != ""
      @item.description = params[:item][:description] if params[:item][:description] != ""

      add_the_item_to_existing_folders(params[:item][:folder_ids], @item) { @item.folders.clear }
      add_the_item_to_the_newly_created_folder(params[:folder][:name], @item)

      @item.save
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

      flash[:success] = "Successfully deleted the item from your account. It no longer exists."
      redirect "/#{current_user.slug}/items"
    else
      flash[:login] = "You are not logged in. Please Log in or Register."
      redirect "/login"
    end
  end

  ###########################################
  # Deletes the item from a specific folder #
  ###########################################
  delete "/:user_slug/folders/:folder_id/items/:item_slug/:item_id/delete" do
    if logged_in?
      @item = current_user.items.find_by_id(params[:item_id])
      @folder = current_user.folders.find_by_id(params[:folder_id])

      if @item && @folder
        @item.folders.delete(Folder.find_by_id(params[:folder_id]))
        @folder.items.delete(Item.find_by_id(params[:item_id]))
      end

      flash[:success] = "Successfully deleted the item [#{@item.name}] from folder [#{@folder.name}]. You can still find it in your items section."
      redirect "/#{current_user.slug}/folders/#{@folder.slug}"

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
