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
      redirect "/login"
    end
  end


  ####################################
  # Retrieves the item creation page #
  ####################################

  get "/:slug/items/new" do
    if logged_in?
      @folders = current_user.folders
      erb :"items/create_item"
    else
      redirect "/login"
    end
  end


  ###############################################
  # Uses the information to create a new item   #
  # And assigns it the respective details       #
  # And associations                            #
  ###############################################

  # WHAT A MONSTER
  # REFACTOR

  post "/:slug/items/new" do
    if logged_in?
      if params[:item][:name].empty?
        redirect "/#{current_user.slug}/items/new"

      else
        @item = Item.create(name: params[:item][:name], description: params[:description], cost: params[:cost])

        add_existing_items_to_the_folder(params[:item][:folder_ids], @item)
        add_the_newly_created_item_to_the_folder(@folder.name, params[:folder][:name])

        @item.save
        redirect "/#{current_user.slug}/items"
      end

    else
      redirect "/login"
    end
  end

  #################################
  # Retrieves the item edit page #
  #################################

  get "/:user_slug/items/:item_slug/:item_id/edit" do
    if logged_in?
      @item = current_user.items.find_by_id(params[:item_id])
      @folders = current_user.folders
      erb :"items/edit_item"
    else
      redirect "/login"
    end
  end


  ########################################
  # Edits the item's details and folders #
  ########################################

  # Looks like a MONSTER
  # REFACTOR

  patch "/:user_slug/items/:item_slug/:item_id/edit" do
    if logged_in?

      @item = current_user.items.find_by_id(params[:item_id])

      add_existing_items_to_the_folder(params[:item][:folder_ids], @item)
      add_the_newly_created_item_to_the_folder(@folder.name, params[:folder][:name])

        @item.save
        redirect "/#{current_user.slug}/items"

    else
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
      redirect "/#{current_user.slug}/items"
    else
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
      redirect "/#{current_user.slug}/folders/#{@folder.slug}"
    else
      redirect "/login"
    end
  end


  #######################################
  # Retrieves the item's show/info page #
  #######################################

  get "/:user_slug/items/:item_slug/:item_id" do
    if logged_in?
      @item = Item.find_by_item_slug(params[:item_slug], params[:item_id].to_i, current_user.id)
      #binding.pry
      erb :"items/show_item"
    else
      redirect "/login"
    end
  end


end
