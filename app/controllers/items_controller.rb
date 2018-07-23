class ItemsController < ApplicationController
  get "/:slug/items" do
    if logged_in?
      @items = Item.all
      erb :"items/item_index"
    else
      redirect "/login"
    end
  end


  get "/items/new" do
    if logged_in?
      erb :"items/create_item"
    else
      redirect "/login"
    end
  end

  post "/items/new" do
    if logged_in?
      # -- DO THIS --
    else
      redirect "/login"
    end
  end

  get "/items/:slug/edit" do
    if logged_in?
      # -- RETRIEVE THIS ERB --
    else
      redirect "/login"
    end
  end

  post "/items/:slug/edit" do
    if logged_in?
      # -- DO THIS --
    else
      redirect "/login"
    end
  end

  delete "/items/:slug/edit" do
    if logged_in?
      # -- DELETE THIS ITEM --
    else
      redirect "/login"
    end
  end

  get "/items/:slug/show" do
    if logged_in?
      # -- SHOW THIS ITEM --
    else
      redirect "/login"
    end
  end


  # GET: display items index - deleting an item from here should delete it completely
  # GET-new: create a new item
  # POST-new: handle the input from the newly created item
  # GET-edit: edit the information for an existing item
  # PATCH-edit: handle the input from the edited information
  # DELETE: deletes an item
end
