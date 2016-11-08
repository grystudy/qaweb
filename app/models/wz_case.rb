class WzCase < ApplicationRecord
  belongs_to :vehicle
  has_many :wz_item
end
