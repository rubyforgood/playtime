# == Schema Information
#
# Table name: wishlists
#
#  id         :integer          not null, primary key
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Wishlist < ApplicationRecord
  has_many :site_managers
  has_many :users, through: :site_managers
  has_many :wishlist_items
  has_many :items, through: :wishlist_items
end
