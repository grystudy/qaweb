class AddIndexToWzItems < ActiveRecord::Migration[5.0]
  def change
    add_index :wz_items, :info
  end
end
