# == Schema Information
#
# Table name: items
#
#  id            :integer          not null, primary key
#  amazon_url    :string
#  associate_url :string
#  price_cents   :integer
#  asin          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  image_url     :string
#  image_height  :integer
#  image_width   :integer
#  name          :text             not null
#

require "rails_helper"

describe Item do
  describe "without a name" do
    subject { build(:item, name: nil) }
    it { should_not be_valid }
  end
end
