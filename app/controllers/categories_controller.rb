categoriesrequire 'pry'

class CategoriesController < ApplicationController

  # There must be a way to refactor this and folders so as to not repeat myself.
  # I could just get rid of the categories altogether...


  ###################################################
  # FOR ALL ROUTES: If the user is not logged in,   #
  # it redirects to the home, signup, or login page #
  ###################################################



  ###################################
  # Displays the User's categories  #
  ###################################
  get "/:slug/categories" do
    if logged_in?
      @categories = current_user.categories
      erb :"categories/category_index"
    else
      redirect "/"
    end
  end

  #####################################
  # Displays the create_category form #
  #####################################
  get "/:slug/categories/new" do
    if logged_in?
      @items = current_user.items
      erb :"categories/create_category"
    else
      redirect "/login"
    end
  end

  ##############################################################
  # Using the input params during category creation to check   #
  # if a category with the same name exists before creating it #
  ##############################################################
  post "/:slug/categories/new" do
    if logged_in?

      if params[:category][:name] == ""
        redirect "/#{current_user.slug}/categories/new"
      else
        @category = Category.create(name: params[:category][:name])

        add_existing_items_to_the_category(params[:category][:item_ids], @category)
        add_the_newly_created_item_to_the_category(params[:item][:name], @category)
        current_user.categories << @category

        redirect "/#{current_user.slug}/categories"
      end #params[:category][:name] empty

    else
      redirect "/login"
    end #logged_in?
  end

  #################################################################
  # Displays the edit_category form                               #
  # Allows the user to add and remove items from the category     #
  # Allows the user to create and add a new item to the category  #
  #################################################################

  get "/:user_slug/categories/:category_slug/edit" do
    if logged_in?
      @category = Category.find_by_category_slug(params[:category_slug], current_user.id)
      @items = current_user.items

      if @category
        erb :"categories/edit_category"
      else
        redirect "/#{current_user.slug}/categories"
      end

    else
      redirect "/login"
    end
  end


  #######################################################################
  # Uses the input information to edit the category's name and contents #
  #######################################################################

  patch "/:user_slug/categories/:category_slug/edit" do
    if logged_in?
      @category = Category.find_by_category_slug(params[:category_slug], current_user.id)
      category_name_exists = !Category.find_by_category_name(params[:category][:name], current_user.id).empty?

      if @category
        if category_name_exists
          redirect "/#{current_user.slug}/categories/#{@category.slug}/edit"

        else
          @category.name = params[:category][:name] if params[:category][:name] != ""
          add_existing_items_to_the_category(params[:category][:item_ids], @category) { @category.items.clear }
          add_the_newly_created_item_to_the_category(params[:item][:name], @category)

          @category.save
          redirect "/#{current_user.slug}/categories"
        end # category_name_exists?
      end #if @category

    else
      redirect "/login"
    end # if logged_in?
  end # patch

  ######################################
  # Show route for a specific category #
  ######################################
  get "/:user_slug/categories/:category_slug" do
    if logged_in?
      @category = Category.find_by_category_slug(params[:category_slug], current_user.id)
      erb :"categories/show_category"
      # lists the items in alphabetical order
    else
      redirect "/login"
    end
  end


  ########################################
  # Delete route for a specific category #
  ########################################

  delete "/:user_slug/categories/:category_slug/delete" do
    if logged_in?

      @category = Category.find_by_category_slug(params[:category_slug], current_user.id)

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
