class CategoriesController < ApplicationController
  #Essentially similar routes to the "FoldersController"
  # -- NOT DRY -- NEED to ADDRESS THIS --
  # ADD FUNCTIONALITY: !! Deleting an item from a specific category should delete it only from that category !! #


  ###################################################
  # FOR ALL ROUTES: If the user is not logged in,   #
  # it redirects to the home, signup, or login page #
  ###################################################

  ############################
  # Retrieves Category Index #
  ############################
  get "/:slug/categories" do
    if logged_in?
      @categories = Category.where(user_id: current_user.id)
      erb :"categories/category_index"
    else
      redirect "/"
    end
  end

  ##################################
  # Retrieves Create Category form #
  ##################################
  get "/categories/new" do
    if logged_in?
      @user = current_user
      erb :"categories/create_category"
    else
      redirect "/login"
    end
  end

  ##############################################################
  # Using the input params during category creation to check   #
  # if a category with the same name exists before creating it #
  ##############################################################
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

  ####################################
  # Retrieves the Category Edit Form #
  ####################################
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


  ######################################################
  # Uses the Information Gathered to Edit the Category #
  ######################################################
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

  #################################################
  # Retrieves the Contents of a Specific Category #
  #################################################
  get "/categories/:slug/items" do
    if logged_in?
      @category = Category.find_by_category_slug(params[:slug], current_user.id)
      erb :"categories/show_category"
      # lists the items in alphabetical order
    else
      redirect "/login"
    end
  end


  ########################################
  # Delete route for a specific category #
  ########################################

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

end
