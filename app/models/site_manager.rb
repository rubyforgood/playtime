# frozen_string_literal: true

# == Schema Information
#
# Table name: site_managers
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  wishlist_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class SiteManager < ApplicationRecord
  belongs_to :user
  belongs_to :wishlist
end
