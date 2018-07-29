module UserFindables

  module ClassMethods

    ##############################
    # Finds the User by the slug #
    ##############################
    def find_by_slug(slug)
      self.all.find {|s| s.slug == slug}
    end


    #################################################
    # Test to see if the input email already exists #
    #################################################

    def find_by_email(record)
      self.where('lower(email) = ?', record.downcase).first
    end


    ####################################################
    # Test to see if the input username already exists #
    ####################################################

    def find_by_username(record)
      self.where('lower(username) = ?', record.downcase).first
    end

  end # class methods module
end # user finables module
