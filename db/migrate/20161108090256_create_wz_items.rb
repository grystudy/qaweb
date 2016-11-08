class CreateWzItems < ActiveRecord::Migration[5.0]
  def change
    create_table :wz_items do |t|
      t.belongs_to :wz_case, foreign_key: true
      t.text :info
      t.timestamps
    end
  end
end
