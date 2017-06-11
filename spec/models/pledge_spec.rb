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

require 'rails_helper'

RSpec.describe Pledge, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
