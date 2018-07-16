class ItemsController < ApplicationController

  get "/:slug/items" do
    if logged_in?
      @user = current_user
      @folder = @user.folders.find_by_slug(params[:slug])
      erb :"folders/show_folder"
    else
      redirect "/login"
    end
  end

end
