class Listing < ActiveRecord::Base
  validates :order, uniqueness: true
end
