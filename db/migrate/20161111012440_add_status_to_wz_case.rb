class AddStatusToWzCase < ActiveRecord::Migration[5.0]
  def change
    add_column :wz_cases, :status, :integer
  end
end
