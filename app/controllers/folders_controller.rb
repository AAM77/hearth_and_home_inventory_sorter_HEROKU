class FoldersController < ApplicationController

  get "/folders/new" do
    if logged_in?
      @user = current_user
      erb :"folders/create_folder"
    else
      redirect "/login"
    end
  end

  get "/:slug/folders" do
    if logged_in?
      @folders = current_user.folders
      erb :"folders/folder_index"
    else
      redirect "/"
    end
  end

  post "/:slug/folders" do
    if logged_in?
      if params[:name] == ""
        redirect "/folders/new"
      else
        @folder = Folder.find_by_case(params[:name])

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


end
