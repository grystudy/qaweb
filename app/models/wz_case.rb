class WzCase < ApplicationRecord
  belongs_to :vehicle
  has_one :wz_item
  has_one :wz_query

  def get_wz_items
    WzCase.parse wz_item
  end

  def get_wz_queries
    WzCase.parse wz_query
  end

  class << self
    def parse i
      return [] unless i
      str_ = i.info
      return [] unless str_
      items = eval str_
      return [] unless items && items.size > 0
      items
    end

    def get_des status_
      return "一致" if status_ == 0
      return "结果包含基准" if status_ == 1
      return "不同" if status_ == 2
      return "未知"
    end
  end
end
