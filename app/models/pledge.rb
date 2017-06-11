# == Schema Information
#
# Table name: pledges
#
#  id         :integer          not null, primary key
#  item_id    :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Pledge < ApplicationRecord
  belongs_to :item
  belongs_to :user

  def self.generate_csv
    CSV.generate do |csv|
      csv << Pledge.column_names
      Pledge.all.each do |pledge|
        csv << pledge.attributes.values
      end
    end
  end

end
