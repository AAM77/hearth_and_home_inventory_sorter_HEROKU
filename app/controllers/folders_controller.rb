class FoldersController < ApplicationController

  ###################################################
  # FOR ALL ROUTES: If the user is not logged in,   #
  # it redirects to the home, signup, or login page #
  ###################################################



  ###################################
  # Displays the User's folders     #
  ###################################
  get "/:slug/folders" do
    if logged_in?
      @path = ""
      @folders = current_user.folders.sort { |a,b| a.name.downcase <=> b.name.downcase }
      erb :"folders/folder_index"
    else
      flash[:login] = "You are not logged in. Please Log in or Register."
      redirect "/"
    end
  end

  ###################################
  # Displays the create_folder form #
  ###################################
  get "/:slug/folders/new" do
    if logged_in?
      @items = current_user.items
      erb :"folders/create_folder"
    else
      flash[:login] = "You are not logged in. Please Log in or Register."
      redirect "/login"
    end
  end

  ############################################################
  # Using the input params during folder creation to check   #
  # if a folder with the same name exists before creating it #
  ############################################################
  post "/:slug/folders/new" do
    if logged_in?

      if params[:folder][:name] == ""
        redirect "/#{current_user.slug}/folders/new"
      else
        folder_name_exists = !Folder.find_by_folder_name(params[:folder][:name], current_user.id).empty?

        if folder_name_exists
          redirect "/#{current_user.slug}/folders/new"
        else
          @folder = Folder.create(name: params[:folder][:name])
          current_user.folders << @folder

          # add selected items to folder
          add_selected_item_folder_category(ifc_ids: params[:folder][:item_ids], new_object: @folder, proc_find: find_folder_proc, proc_add_item: item_to_new_folder_proc)

          # add new item to folder
          add_the_newly_created_item(name: params[:item][:name], description: params[:item][:description], cost: params[:item][:cost], @folder)


          redirect "/#{current_user.slug}/folders"
        end #if folder_exists
      end #params[:folder][:name] empty

    else
      flash[:login] = "You are not logged in. Please Log in or Register."
      redirect "/login"
    end #logged_in?
  end

  ###############################################################
  # Displays the edit_folder form                               #
  # Allows the user to add and remove items from the folder     #
  # Allows the user to create and add a new item to the folder  #
  ###############################################################

  get "/:user_slug/folders/:folder_slug/edit" do
    if logged_in?
      @folder = Folder.find_by_folder_slug(params[:folder_slug], current_user.id)
      @items = current_user.items

      if @folder
        erb :"folders/edit_folder"
      else
        redirect "/#{current_user.slug}/folders"
      end

    else
      flash[:login] = "You are not logged in. Please Log in or Register."
      redirect "/login"
    end
  end


  ######################################################################
  # Uses the input information to edit the folder's name and contents #
  ######################################################################

  patch "/:user_slug/folders/:folder_slug/edit" do
    if logged_in?
      @folder = Folder.find_by_folder_slug(params[:folder_slug], current_user.id)

      folder_name_exists = !Folder.find_by_folder_name(params[:folder][:name], current_user.id).empty?

      if @folder
        if folder_name_exists
          redirect "/#{current_user.slug}/folders/#{@folder.slug}/edit"

        else
          @folder.name = params[:folder][:name] if !params[:folder][:name].blank?

          @folder.save

          # add selected items to folder
          add_selected_item_folder_category(ifc_ids: params[:folder][:item_ids], new_object: @folder, proc_find: find_folder_proc, proc_add_item: item_to_new_folder_proc) { @folder.items.clear }

          # add new item to folder
          add_the_newly_created_item(name: params[:item][:name], description: params[:item][:description], cost: params[:item][:cost], @folder)



          flash[:success] = "Successfully updated folder details for folder: [#{@folder.name}]."
          redirect "/#{current_user.slug}/folders/#{@folder.slug}"
        end
      end

    else
      flash[:login] = "You are not logged in. Please Log in or Register."
      redirect "/login"
    end
  end


  ####################################
  # Show route for a specific folder #
  ####################################
  get "/:user_slug/folders/:folder_slug" do
    if logged_in?
      @folder = Folder.find_by_folder_slug(params[:folder_slug], current_user.id)
      @items = @folder.items.sort { |a,b| a.name.downcase <=> b.name.downcase }
      erb :"folders/show_folder"
    else
      flash[:warning] = "You are not logged in. Please Log in or Register."
      redirect "/login"
    end
  end


  ######################################
  # Delete route for a specific folder #
  ######################################

  delete "/:user_slug/folders/:folder_slug/delete" do
    if logged_in?

      @folder = Folder.find_by_folder_slug(params[:folder_slug], current_user.id)

      if @folder.user_id == current_user.id
        @folder.destroy
        flash[:success] = "Successfully deleted folder: [ #{@folder.name} ]"
        redirect "/#{current_user.slug}/folders"
      else
        flash[:warning] = "ERROR: Could not delete folder: [ #{@folder.name} ]."
        redirect "/#{current_user.slug}/folders"
      end

    else
      flash[:login] = "You are not logged in. Please Log in or Register."
      redirect "/login"
    end
  end


end
