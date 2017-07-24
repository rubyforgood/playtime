# == Schema Information
#
# Table name: users
#
#  id             :integer          not null, primary key
#  name           :text
#  email          :text             not null
#  admin          :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  amazon_user_id :string
#  zipcode        :string
#  site_manager   :boolean
#

require "amazon_oauth_info"
require "active_record_csv_generator"

class User < ApplicationRecord
  validates :email,          uniqueness: true,
                             presence: true
  validates :amazon_user_id, uniqueness: true,
                             allow_blank: true

  has_many :site_managers
  has_many :wishlists, through: :site_managers

  def can_manage?(wishlist)
    admin? || wishlists.exists?(wishlist.id)
  end

  def display_name
    name || email
  end

  def logged_in?
    true
  end

  def self.generate_csv(csv_generator: ActiveRecordCSVGenerator.new(self))
    csv_generator.generate
  end

  def self.find_or_create_from_amazon_hash!(hash)
    oauth_info = AmazonOAuthInfo.new(hash)

    find_by_amazon_user_id(oauth_info.amazon_user_id) ||
      find_by_email(oauth_info.email) ||
      create!(
        name:           oauth_info.name,
        email:          oauth_info.email,
        amazon_user_id: oauth_info.amazon_user_id,
        zipcode:        oauth_info.zipcode
      )
  end
end
