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

class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true

  has_many :site_managers
  has_many :wishlists, through: :site_managers

  def self.generate_csv
    CSV.generate do |csv|
      csv << User.column_names
      User.all.each do |user|
        csv << user.attributes.values
      end
    end
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

  def can_manage?(wishlist)
    admin? || wishlists.exists?(wishlist.id)
  end

  def display_name
    name || email
  end

  class AmazonOAuthInfo
    attr_reader :hash

    def initialize(hash)
      @hash = hash
    end

    def amazon_user_id
      hash["uid"]
    end

    def email
      hash["info"]["email"]
    end

    def name
      hash["info"]["name"]
    end

    def zipcode
      hash["extra"]["postal_code"]
    end
  end
end
