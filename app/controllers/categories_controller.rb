class CategoriesController < ApplicationController
  #Essentially similar routes to the "FoldersController"
  # -- NOT DRY -- ADDRESS THIS -- 
  # ADD FUNCTIONALITY: !! Deleting an item from a specific category should delete it only from that category !! #

  ###################################
  # Displays the User's categories     #
  ###################################
  get "/:slug/categories" do
    if logged_in?
      @categories = Category.where(user_id: current_user.id)
      erb :"categories/category_index"
    else
      redirect "/"
    end
  end

  ###################################
  # Displays the create_category form #
  ###################################
  get "/categories/new" do
    if logged_in?
      @user = current_user
      erb :"categories/create_category"
    else
      redirect "/login"
    end
  end

  ############################################################
  # Using the input params during category creation to check   #
  # if a category with the same name exists before creating it #
  ############################################################
  post "/:slug/categories" do
    if logged_in?
      if params[:name] == ""
        redirect "/categories/new"
      else
        @user = current_user
        @category = Category.find_by_category_name(params[:name], current_user.id)

        if !@category.empty?
          redirect "/categories/new"
        else
          @category = Category.new(name: params[:name])
          @category.user_id = current_user.id
          @category.save
          redirect "/#{current_user.slug}/categories"
        end #@category
      end #params[:name] empty

    else
      redirect "/login"
    end #loggend_in?
  end

  #################################
  # Displays the edit_category form #
  #################################
  get "/categories/:slug/edit" do
    if logged_in?
      @category = Category.find_by_category_slug(params[:slug], current_user.id)

      if @category
        erb :"categories/edit_category"
      else
        redirect "/#{current_user.slug}/categories"
      end

    else
      redirect "/login"
    end
  end

  patch "/categories/:slug/edit" do
    if logged_in?

      @category = Category.find_by_category_slug(params[:slug], current_user.id)
      category_exists = !Category.find_by_category_name(params[:name], current_user.id).empty?

      if @category
        #binding.pry

        if category_exists
          #binding.pry
          redirect "/categories/#{@category.slug}/edit"
        else
          @category.name = params[:name] if params[:name] != ""
          @category.user_id = current_user.id
          @category.save
          redirect "/#{current_user.slug}/categories"
        end # @category.

      else
        redirect "/#{current_user.slug}/categories"
      end #category.user_id == current_user.id

    else
      redirect "/login"
    end
  end

  ####################################
  # Show route for a specific category #
  ####################################
  get "/categories/:slug/items" do
    if logged_in?
      @category = Category.find_by_category_slug(params[:slug], current_user.id)
      erb :"categories/show_category"
      # lists the items in alphabetical order
    else
      redirect "/login"
    end
  end


  ######################################
  # Delete route for a specific category #
  ######################################

  delete "/categories/:slug/delete" do
    if logged_in?
      @category = Category.find_by_category_slug(params[:slug], current_user.id)
      if @category.user_id == current_user.id
        @category.destroy
        flash[:success_message] = "Successfully deleted category: [ #{@category.name} ]"
        redirect "/#{current_user.slug}/categories"
      else
        flash[:fail_message] = "ERROR: Could not delete category: [ #{@category.name} ]."
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
