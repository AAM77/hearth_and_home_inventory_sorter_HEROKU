module UserHelpers

  ############################################
  # CLASS METHODS
  ############################################

    module ClassMethods
      def create_user(username:, email:, password:)
        new_user = self.new(username: username, email: email, password: password)
        new_user.initial_folders
        new_user.initial_categories
        new_user.save
        new_user
      end
    end

  ############################################
  # INSTANCE METHODS
  ############################################

  module InstanceMethods
    ###########################################################
    # Convert the Username to a slug that can be searched for #
    ###########################################################
    def slug
      self.username.gsub(" ", "-")
    end

    #############################################################
    # Add the following folders to this User (upon registraion) #
    #############################################################
    def initial_folders
      self.folders << Folder.create(name: "Home")
      self.folders << Folder.create(name: "Work")
    end


    ################################################################
    # Add the following categories to this User (upon registraion) #
    ################################################################

    def initial_categories
      self.categories << Category.create(name: "Books")
      self.categories << Category.create(name: "Clothes")
      self.categories << Category.create(name: "Electronics")
      self.categories << Category.create(name: "Furniture")
      self.categories << Category.create(name: "Health and Fitness")
      self.categories << Category.create(name: "Kitchenware")
      self.categories << Category.create(name: "Office Supplies")
      self.categories << Category.create(name: "Personal Grooming")
      self.categories << Category.create(name: "Shoes")
      self.categories << Category.create(name: "Video Games")
    end

    ####################################################
    # Test to see if the input username already exists #
    ####################################################
    def create_folder(folder_name)
      folder = self.folders.where("lower(name) = ?", folder_name.downcase)

      if !folder.nil? #if a folder with that name does not exist
        self.folders << Folder.create(name: folder_name)
        self.save(validate: false)
      end
    end
  end

end
