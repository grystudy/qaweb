class WzCase < ApplicationRecord
  belongs_to :vehicle
  has_one :wz_item

  def get_wz_items
    WzCase.parse wz_item
  end

  class << self
    def parse str_
      return [] unless str_
      items = eval str_
      return [] unless items && items.size > 0
      items
    end
  end
end
