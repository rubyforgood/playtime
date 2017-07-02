# == Schema Information
#
# Table name: pledges
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  wishlist_item_id :integer
#

require "active_record_csv_generator"

class Pledge < ApplicationRecord
  belongs_to :wishlist_item
  belongs_to :user

  def self.generate_csv(csv_generator: ActiveRecordCSVGenerator.new(self))
    csv_generator.generate
  end
end
