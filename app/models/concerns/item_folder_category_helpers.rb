module ItemFolderCategoryHelpers

  ############################################
  # CLASS METHODS
  ############################################

  module ClassMethods

    ###############################################################
    # Finds the item by the slug, item id, the user id.           #
    # This is important because each user can create items        #
    # with the same name as another user, so a slug is not        #
    # enough. Also, a user might want to add that same item to    #
    # multiple folders or categoies. Therefore, we would have     #
    # multiple items with the same slug and even user             #
    ###############################################################
    def find_by_item_slug(slug, item_id, user_id)
      self.all.find {|s| s.slug == slug && s.id == item_id && s.user_id == user_id}
    end

    ###############################################################
    # Finds the folder or category by the slug and the user id    #
    # This is important because each user can create folders      #
    # with the same name as another user, so a slug is not enough #
    ###############################################################
    def find_by_slug_and_user(slug, user_id)
      self.all.find { |s| s.slug == slug && s.user_id == user_id }
    end

    ###############################################################
    # Finds the folder or category by the name and the user id    #
    # This is important because each user can create folders      #
    # with the same name as another user, so a slug is not enough #
    ###############################################################
    def find_by_name(record, user_id)
      self.where("lower(name) = ? AND user_id = ?", record.downcase, user_id)
    end

  end

############################################
# INSTANCE METHODS
############################################

  module InstanceMethods

    #####################################
    # slugs the name by replacings the  #
    # spaces with hyphens. This makes   #
    # it easier to read.                #
    #####################################

    def slug
      self.name.gsub(" ", "-")
    end

  end

end # ItemFolderCategoryHelpers module
