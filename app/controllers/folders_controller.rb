require 'pry'

class FoldersController < ApplicationController
  # ADD FUNCTIONALITY: !! Deleting an item from a specific folder should delete it only from that folder !! #

  ###################################
  # Displays the User's folders     #
  ###################################
  get "/:slug/folders" do
    if logged_in?
      @folders = Folder.where(user_id: current_user.id)
      erb :"folders/folder_index"
    else
      redirect "/"
    end
  end

  ###################################
  # Displays the create_folder form #
  ###################################
  get "/:slug/folders/new" do
    if logged_in?
      @items = current_user.items
      erb :"folders/create_folder"
    else
      redirect "/login"
    end
  end

  ############################################################
  # Using the input params during folder creation to check   #
  # if a folder with the same name exists before creating it #
  ############################################################
  post "/:slug/folders/new" do
    if logged_in?
      if params[:folder][:name] == ""
        redirect "/#{current_user.slug}/folders/new"
      else
        @folder = Folder.create(name: params[:folder][:name])

        if params[:folder][:item_ids]
          params[:folder][:item_ids].each do |item_id|
            @folder.items << current_user.items.find_by_id(item_id)
          end
        end

        if !params[:item][:name].empty?
          new_item = Item.create(name: params[:item][:name])
          @folder.items << new_item
          current_user.items << new_item
        end

        current_user.folders << @folder
        #binding.pry
        redirect "/#{current_user.slug}/folders"
      end #params[:folder][:name] empty

    else
      redirect "/login"
    end #loggend_in?
  end


  #@folder = current_user.create_folder(params[:folder][:name]) {redirect "/current_user.slug/folders/new"}

  #if !params[:item][:name].empty?
  #  #current_user.folders.where("lower(name) = ?", params[:folder][:name].downcase)
  #  @folder.items << Item.create(name: params[:item][:name])
  #end

  #redirect "/#{current_user.slug}/folders"





  #################################
  # Displays the edit_folder form #
  #################################
  get "/:user_slug/folders/:folder_slug/edit" do
    if logged_in?
      @folder = Folder.find_by_folder_slug(params[:folder_slug], current_user.id)
      @items = current_user.items

      if @folder
        erb :"folders/edit_folder"
      else
        redirect "/#{current_user.slug}/folders"
      end

    else
      redirect "/login"
    end
  end

  patch "/:user_slug/folders/:folder_slug/edit" do
    if logged_in?

      @folder = Folder.find_by_folder_slug(params[:folder_slug], current_user.id)
      folder = Folder.find_by_folder_name(params[:name], current_user.id)

      if @folder
        #binding.pry

        if !folder.empty?
          #binding.pry
          redirect "/#{current_user.slug}/folders/#{@folder.slug}/edit"
        else
          @folder.name = params[:name] if params[:name] != ""

          if params[:folder][:item_ids]
            @folder.items.clear
            params[:folder][:item_ids].each do |item_id|
              #item = @folder.items.where(id: item_id)
              #if !@folder.items.include?(item)
              @folder.items << current_user.items.find_by_id(item_id)
              #end
            end
          end

          if !params[:item][:name].empty?
            new_item = Item.create(name: params[:item][:name])
            @folder.items << new_item
            current_user.items << new_item
          end

          @folder.save
          redirect "/#{current_user.slug}/folders"
        end # @folder.

      else
        redirect "/#{current_user.slug}/folders"
      end #folder.user_id == current_user.id

    else
      redirect "/login"
    end
  end

  ####################################
  # Show route for a specific folder #
  ####################################
  get "/:user_slug/folders/:folder_slug/items" do
    if logged_in?
      @folder = Folder.find_by_folder_slug(params[:folder_slug], current_user.id)
      erb :"folders/show_folder"
      # lists the items in alphabetical order
    else
      redirect "/login"
    end
  end


  ######################################
  # Delete route for a specific folder #
  ######################################

  delete "/:user_slug/folders/:folder_slug/delete" do
    if logged_in?
      @folder = Folder.find_by_folder_slug(params[:folder_slug], current_user.id)
      if @folder.user_id == current_user.id
        @folder.destroy
        flash[:success_message] = "Successfully deleted folder: [ #{@folder.name} ]"
        redirect "/#{current_user.slug}/folders"
      else
        flash[:fail_message] = "ERROR: Could not delete folder: [ #{@folder.name} ]."
        redirect "/#{current_user.slug}"
      end
    else
      redirect "/login"
    end
  end





  # I ned a get route for edit.erb

  # I need a post route edit.erb

  # I need a delete route (with a warning message if it contains items)



end
