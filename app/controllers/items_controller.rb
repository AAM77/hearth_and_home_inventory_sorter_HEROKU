class ItemsController < ApplicationController
  get "/:slug/items" do
    if logged_in?
      @items = Item.all
      erb :"items/item_index"
    else
      redirect "/login"
    end
  end

  get "/:slug/items/new" do
    if logged_in?
      erb :"items/create_item"
    else
      redirect "/login"
    end
  end

  post "/:slug/items/new" do
    if logged_in?
      @item = Item.new(name: params[:name], description: params[:description], cost: params[:cost])
      @item.user_id = current_user.id
      @item.save
      redirect "/#{current_user.slug}/items"
    else
      redirect "/login"
    end
  end

  get "/:user_slug/items/:item_slug/edit" do
    if logged_in?
      erb :"items/edit_item"
    else
      redirect "/login"
    end
  end

  post "/:user_slug/items/:item_slug/edit" do
    if logged_in?
      redirect "/#{current_user.slug}/items"
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
