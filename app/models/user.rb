# frozen_string_literal: true

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
#

require 'amazon_oauth_info'
require 'active_record_csv_generator'

class User < ApplicationRecord
  validates :email,          uniqueness: true,
                             presence: true
  validates :amazon_user_id, uniqueness: true,
                             allow_blank: true

  has_many :pledges, dependent: :nullify
  has_many :wishlist_items, through: :pledges
  has_many :site_managers, dependent: :destroy
  has_many :wishlists, through: :site_managers

  scope :admin, -> { where(admin: true) }

  def pledge_for(wishlist_item)
    pledges.find_by(wishlist_item_id: wishlist_item.id)
  end

  def can_manage?(wishlist)
    admin? || wishlists.exists?(wishlist.id)
  end

  def pledged?(pledge)
    pledges.include? pledge
  end

  def display_name
    name || email
  end

  def logged_in?
    true
  end

  def site_manager?
    wishlists.exists?
  end

  def pledge_count
    pledges.pluck(:quantity).sum
  end

  def self.generate_csv(csv_generator: ActiveRecordCSVGenerator.new(self))
    csv_generator.generate(columns: [
                             :name,
                             :email,
                             :zipcode,
                             ['admin?', ->(u) { u.admin }],
                             ['site manager?', ->(u) { u.site_manager? }],
                             ['pledge count', ->(u) { u.pledge_count }],
                             ['created at', ->(u) { u.created_at }]
                           ])
  end

  def self.find_or_create_from_amazon_hash!(hash)
    oauth_info = AmazonOAuthInfo.new(hash)

    find_by(amazon_user_id: oauth_info.amazon_user_id) ||
      find_by(email: oauth_info.email) ||
      create!(
        name:           oauth_info.name,
        email:          oauth_info.email,
        amazon_user_id: oauth_info.amazon_user_id,
        zipcode:        oauth_info.zipcode
      )
  end
end
