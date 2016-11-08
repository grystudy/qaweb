class CreateWzCases < ActiveRecord::Migration[5.0]
  def change
    create_table :wz_cases do |t|
      t.belongs_to :vehicle, foreign_key: true

      t.timestamps
    end
  end
end
