require 'pry'

class FoldersController < ApplicationController

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
  get "/folders/new" do
    if logged_in?
      @user = current_user
      erb :"folders/create_folder"
    else
      redirect "/login"
    end
  end

  ############################################################
  # Using the input params during folder creation to check   #
  # if a folder with the same name exists before creating it #
  ############################################################
  post "/:slug/folders" do
    if logged_in?
      if params[:name] == ""
        redirect "/folders/new"
      else
        @user = current_user
        @folder = Folder.find_by_folder(params[:name], current_user.id)

        if !@folder.empty?
          redirect "/folders/new"
        else
          @folder = Folder.new(name: params[:name])
          @folder.user_id = current_user.id
          @folder.save
          redirect "/#{current_user.slug}/folders"
        end #@folder
      end #params[:name] empty

    else
      redirect "/login"
    end #loggend_in?
  end

  #################################
  # Displays the edit_folder form #
  #################################
  get "/folders/:slug/edit" do
    if logged_in?
      @folder = Folder.find_by_folder_slug(params[:slug], current_user.id)

      if @folder
        erb :"folders/edit_folder"
      else
        redirect "/#{current_user.slug}/folders"
      end

    else
      redirect "/login"
    end
  end

  patch "/folders/:slug/edit" do
    if logged_in?

      @folder = Folder.find_by_folder_slug(params[:slug], current_user.id)

      if @folder
        #binding.pry

        if Folder.find_by_folder_name(params[:name], current_user.id)
          redirect "/folders/#{@folder.slug}/edit"
        else
          @folder.name = params[:name] if params[:name] != ""
          @folder.user_id = current_user.id
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
  get "/folders/:slug/items" do
    if logged_in?
      @folder = Folder.find_by_folder_slug(params[:slug], current_user.id)
      erb :"folders/show_folder"
      # lists the items in alphabetical order
    else
      redirect "/login"
    end
  end



  # I ned a get route for edit.erb

  # I need a post route edit.erb

  # I need a delete route (with a warning message if it contains items)



end
