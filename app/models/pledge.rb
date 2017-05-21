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
