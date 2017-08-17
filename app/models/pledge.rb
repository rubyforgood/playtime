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

require "active_record_csv_generator"

class Pledge < ApplicationRecord
  belongs_to :wishlist_item
  belongs_to :user

  validates :quantity, presence: true,
                       numericality: { greater_than_or_equal_to: 1 }

  def self.generate_csv(csv_generator: ActiveRecordCSVGenerator.new(self))
    csv_generator.generate
  end
end
