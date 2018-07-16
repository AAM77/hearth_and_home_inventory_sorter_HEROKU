class ItemsController < ApplicationController

  get "/:slug/items" do
    if logged_in?
      @folder = current_user.folders.find_by_slug(params[:slug])
      erb :"folders/show_folder"
    else
      redirect "/login"
    end
  end

end
