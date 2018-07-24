class ItemsController < ApplicationController
  get "/:slug/items" do
    if logged_in?
      @items = Item.where(user_id: current_user.id)
      erb :"items/item_index"
    else
      redirect "/login"
    end
  end

  get "/:slug/items/new" do
    if logged_in?
      @folders = current_user.folders
      erb :"items/create_item"
    else
      redirect "/login"
    end
  end

  post "/:slug/items/new" do
    if logged_in?
      if params[:item][:name].empty?
        redirect "/#{current_user.slug}/items/new"

      else
        @item = Item.create(name: params[:item][:name], description: params[:description], cost: params[:cost])

        if params[:item][:folder_ids]
          params[:item][:folder_ids].each do |folder_id|
            folder = current_user.folders.find_by_id(folder_id)
            folder.items << @item
            current_user.items << @item
          end
        end

        if !params[:folder][:name].empty?
          new_folder = Folder.create(name: params[:folder][:name])
          new_folder.items << @item
          current_user.folders << new_folder
        end

        @item.save
        redirect "/#{current_user.slug}/items"
      end

    else
      redirect "/login"
    end
  end

  get "/:user_slug/items/:item_slug/:item_id/edit" do
    if logged_in?
      @item = current_user.items.find_by_id(params[:item_id])
      @folders = current_user.folders
      erb :"items/edit_item"
    else
      redirect "/login"
    end
  end

  patch "/:user_slug/items/:item_slug/:item_id/edit" do
    if logged_in?

      @item = current_user.items.find_by_id(params[:item_id])

      if params[:item][:folder_ids]
        params[:item][:folder_ids].each do |folder_id|
          folder = current_user.folders.find_by_id(folder_id)
          folder.items << @item
          current_user.items << @item
        end
      end

      if !params[:folder][:name].empty?
        new_folder = Folder.create(name: params[:folder][:name])
        new_folder.items << @item
        current_user.folders << new_folder
      end

        @item.save
        redirect "/#{current_user.slug}/items"

    else
      redirect "/login"
    end

  end

  delete "/:user_slug/items/:item_slug/:item_id/delete" do
    if logged_in?
      @item = Item.find_by_item_slug(params[:item_slug], params[:item_id].to_i, current_user.id)
      @item.destroy
      redirect "/#{current_user.slug}/items"
    else
      redirect "/login"
    end
  end

  get "/:user_slug/items/:item_slug/:item_id/show" do
    if logged_in?
      @item = Item.find_by_item_slug(params[:item_slug], params[:item_id].to_i, current_user.id)
      #binding.pry
      erb :"items/show_item"
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
