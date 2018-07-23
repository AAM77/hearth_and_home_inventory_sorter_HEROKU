class CategoriesController < ApplicationController
  #Essentially similar routes to the "FoldersController"

  # ADD FUNCTIONALITY: !! Deleting an item from a specific categroy should delete it only from that categroy !! #

  ###################################
  # Displays the User's categories     #
  ###################################
  get "/:slug/categories" do
    if logged_in?
      @categories = Category.where(user_id: current_user.id)
      erb :"categories/categroy_index"
    else
      redirect "/"
    end
  end

  ###################################
  # Displays the create_categroy form #
  ###################################
  get "/categories/new" do
    if logged_in?
      @user = current_user
      erb :"categories/create_categroy"
    else
      redirect "/login"
    end
  end

  ############################################################
  # Using the input params during categroy creation to check   #
  # if a categroy with the same name exists before creating it #
  ############################################################
  post "/:slug/categories" do
    if logged_in?
      if params[:name] == ""
        redirect "/categories/new"
      else
        @user = current_user
        @categroy = Category.find_by_categroy_name(params[:name], current_user.id)

        if !@categroy.empty?
          redirect "/categories/new"
        else
          @categroy = Category.new(name: params[:name])
          @categroy.user_id = current_user.id
          @categroy.save
          redirect "/#{current_user.slug}/categories"
        end #@categroy
      end #params[:name] empty

    else
      redirect "/login"
    end #loggend_in?
  end

  #################################
  # Displays the edit_categroy form #
  #################################
  get "/categories/:slug/edit" do
    if logged_in?
      @categroy = Category.find_by_categroy_slug(params[:slug], current_user.id)

      if @categroy
        erb :"categories/edit_categroy"
      else
        redirect "/#{current_user.slug}/categories"
      end

    else
      redirect "/login"
    end
  end

  patch "/categories/:slug/edit" do
    if logged_in?

      @categroy = Category.find_by_categroy_slug(params[:slug], current_user.id)
      categroy_exists = !Category.find_by_categroy_name(params[:name], current_user.id).empty?

      if @categroy
        #binding.pry

        if categroy_exists
          #binding.pry
          redirect "/categories/#{@categroy.slug}/edit"
        else
          @categroy.name = params[:name] if params[:name] != ""
          @categroy.user_id = current_user.id
          @categroy.save
          redirect "/#{current_user.slug}/categories"
        end # @categroy.

      else
        redirect "/#{current_user.slug}/categories"
      end #categroy.user_id == current_user.id

    else
      redirect "/login"
    end
  end

  ####################################
  # Show route for a specific categroy #
  ####################################
  get "/categories/:slug/items" do
    if logged_in?
      @categroy = Category.find_by_categroy_slug(params[:slug], current_user.id)
      erb :"categories/show_categroy"
      # lists the items in alphabetical order
    else
      redirect "/login"
    end
  end


  ######################################
  # Delete route for a specific categroy #
  ######################################

  delete "/categories/:slug/delete" do
    if logged_in?
      @categroy = Category.find_by_categroy_slug(params[:slug], current_user.id)
      if @categroy.user_id == current_user.id
        @categroy.destroy
        flash[:success_message] = "Successfully deleted categroy: [ #{@categroy.name} ]"
        redirect "/#{current_user.slug}/categories"
      else
        flash[:fail_message] = "ERROR: Could not delete categroy: [ #{@categroy.name} ]."
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
