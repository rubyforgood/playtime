class Pledge < ApplicationRecord
  belongs_to :item
  has_one :user
end
