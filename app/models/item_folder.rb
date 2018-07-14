class ItemFolder < ActiveRecord::Base
  belongs_to :item
  belongs_to :folder
end
