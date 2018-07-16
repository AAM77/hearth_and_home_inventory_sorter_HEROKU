class FoldersController < ApplicationController

  get "/:slug/folders" do
    if logged_in?
      @user = current_user
      @folders = @user.folders
      erb :"folders/folder_index"
    else
      redirect "/"
    end
  end


end
