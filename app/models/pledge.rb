# frozen_string_literal: true

# == Schema Information
#
# Table name: pledges
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  wishlist_item_id :integer
#  quantity         :integer          default(1), not null
#

require 'active_record_csv_generator'

class Pledge < ApplicationRecord
  belongs_to :wishlist_item
  belongs_to :user, optional: true

  delegate :wishlist, :item,        to: :wishlist_item
  delegate :image_url, :amazon_url, to: :item

  delegate :name, to: :wishlist, prefix: true
  delegate :name, to: :item,     prefix: true

  validates :quantity, presence: true,
                       numericality: { greater_than_or_equal_to: 1 }
  validates :wishlist_item, uniqueness: { scope: :user }, unless: :anonymous?

  class << self
    def increment_or_new(params)
      if (pledge = find_duplicate(params))
        pledge.increment(:quantity)
      else
        new(params)
      end
    end

    def generate_csv(csv_generator: ActiveRecordCSVGenerator.new(self))
      csv_generator.generate(columns: [
                               ['pledged item', ->(p) { p.item_name }],
                               ['wishlist',      ->(p) { p.wishlist_name }],
                               ['pledging user', ->(p) { p.user_display_name }],
                               ['email',         ->(p) { p.user_email }],
                               :quantity,
                               ['created at', ->(p) { p.created_at }],
                               ['updated at', ->(p) { p.updated_at }]
                             ])
    end

    private

    def find_duplicate(params)
      uniq_keys = %w[user_id wishlist_item_id]
      uniq_params = params.keep_if { |key, _| key.to_s.in? uniq_keys }
      find_by(uniq_params)
    end
  end

  def anonymous?
    !user_id
  end

  def edited?
    created_at != updated_at
  end

  def user_email
    anonymous? ? nil : user.email
  end

  def user_display_name
    anonymous? ? 'Anonymous' : user.display_name
  end

  def claim_or_increment(user_id:)
    existing_pledge = Pledge.find_by(user_id: user_id,
                                     wishlist_item_id: wishlist_item.id)

    transaction do
      merge!(existing_pledge) if existing_pledge
      update(user_id: user_id)
    end
  end

  private

  def merge!(old_pledge)
    transaction do
      increment(:quantity, old_pledge.quantity)
      old_pledge.destroy
    end
  end
end
