class CreateWzQueries < ActiveRecord::Migration[5.0]
  def change
    create_table :wz_queries do |t|
      t.text :info
      t.references :wz_case, foreign_key: true

      t.timestamps
    end
  end
end
