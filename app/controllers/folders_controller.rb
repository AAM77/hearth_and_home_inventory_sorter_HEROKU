class FoldersController < ApplicationController

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

  ###################################
  # Displays the User's folders     #
  ###################################
  get "/:slug/folders" do
    if logged_in?
      @folders = current_user.folders
      erb :"folders/folder_index"
    else
      redirect "/"
    end
  end

  ###################################
  # Verifies if the folder exists   #
  ###################################
  post "/:slug/folders" do
    if logged_in?
      if params[:name] == ""
        redirect "/folders/new"
      else
        @user = current_user
        @folder = current_user.find_by_folder(params[:name])

        if @folder
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

  get "/folders/:slug/items" do
    if logged_in?
      @folder = current_user.folders.find_by_slug(params[:slug])
      erb :"folders/show_folder"
    else
      redirect "/login"
    end
  end

end
