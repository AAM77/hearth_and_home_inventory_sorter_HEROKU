class CategoriesController < ApplicationController

  ###################################################
  # FOR ALL ROUTES: If the user is not logged in,   #
  # it redirects to the home, signup, or login page #
  ###################################################



  ######################################
  # Displays the User's categories     #
  ######################################
  get "/:slug/categories" do
    if logged_in?
      @path = ""
      @categories = current_user.categories.sort { |a,b| a.name.downcase <=> b.name.downcase }
      erb :"categories/category_index"
    else
      flash[:login] = "You are not logged in. Please Log in or Register."
      redirect "/"
    end
  end

  ###################################
  # Displays the create_category form #
  ###################################
  get "/:slug/categories/new" do
    if logged_in?
      @items = current_user.items
      erb :"categories/create_category"
    else
      flash[:login] = "You are not logged in. Please Log in or Register."
      redirect "/login"
    end
  end

  ############################################################
  # Using the input params during category creation to check   #
  # if a category with the same name exists before creating it #
  ############################################################
  post "/:slug/categories/new" do
    if logged_in?

      if params[:category][:name] == ""
        redirect "/#{current_user.slug}/categories/new"
      else
        category_name_exists = !Category.find_by_name(params[:category][:name], current_user.id).empty?

        if category_name_exists
          redirect "/#{current_user.slug}/categories/new"

        else
          @category = Category.create(name: params[:category][:name])

          current_user.categories << @category

          #procs
          find_item = find_item_proc
          item_to_new_category = item_to_new_category_proc

          # add selected items to folder
          add_selected_item_folder_category(ifc_ids: params[:category][:item_ids], new_object: @category, find_proc: find_item, add_item_proc: item_to_new_category)

          # add new item to folder
          add_the_newly_created_item(name: params[:item][:name], description: params[:item][:description], cost: params[:item][:cost], new_folder_category: @category)

          redirect "/#{current_user.slug}/categories"
        end #if category_exists
      end #params[:category][:name] empty

    else
      flash[:login] = "You are not logged in. Please Log in or Register."
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
      @category = Category.find_by_slug_and_user(params[:category_slug], current_user.id)
      @items = current_user.items

      if @category
        erb :"categories/edit_category"
      else
        redirect "/#{current_user.slug}/categories"
      end

    else
      flash[:login] = "You are not logged in. Please Log in or Register."
      redirect "/login"
    end
  end


  ######################################################################
  # Uses the input information to edit the category's name and contents #
  ######################################################################

  patch "/:user_slug/categories/:category_slug/edit" do
    if logged_in?
      @category = Category.find_by_slug_and_user(params[:category_slug], current_user.id)
      category_name_exists = !Category.find_by_name(params[:category][:name], current_user.id).empty?

      if @category
        if category_name_exists
          redirect "/#{current_user.slug}/categories/#{@category.slug}/edit"

        else
          @category.name = params[:category][:name] if !params[:category][:name].blank?

          @category.save

          #procs
          find_item = find_item_proc
          item_to_new_category = item_to_new_category_proc

          # add selected items to folder
          add_selected_item_folder_category(ifc_ids: params[:category][:item_ids], new_object: @category, find_proc: find_item, add_item_proc: item_to_new_category) { @category.items.clear }

          # add new item to folder
          add_the_newly_created_item(name: params[:item][:name], description: params[:item][:description], cost: params[:item][:cost], new_folder_category: @category)

          flash[:success] = "Successfully updated category details for category: [#{@category.name}]."
          redirect "/#{current_user.slug}/categories/#{@category.slug}"
        end
      end

    else
      flash[:login] = "You are not logged in. Please Log in or Register."
      redirect "/login"
    end
  end


  ######################################
  # Show route for a specific category #
  ######################################
  get "/:user_slug/categories/:category_slug" do
    if logged_in?
      @category = Category.find_by_slug_and_user(params[:category_slug], current_user.id)
      @items = @category.items.sort { |a,b| a.name.downcase <=> b.name.downcase }
      erb :"categories/show_category"
    else
      flash[:warning] = "You are not logged in. Please Log in or Register."
      redirect "/login"
    end
  end


  ########################################
  # Delete route for a specific category #
  ########################################

  delete "/:user_slug/categories/:category_slug/delete" do
    if logged_in?

      @category = Category.find_by_slug_and_user(params[:category_slug], current_user.id)

      if @category.user_id == current_user.id
        @category.destroy
        flash[:success] = "Successfully deleted category: [ #{@category.name} ]"
        redirect "/#{current_user.slug}/categories"

      else
        flash[:warning] = "ERROR: Could not delete category: [ #{@category.name} ]."
        redirect "/#{current_user.slug}/categories"
      end

    else
      flash[:login] = "You are not logged in. Please Log in or Register."
      redirect "/login"
    end
  end


end
