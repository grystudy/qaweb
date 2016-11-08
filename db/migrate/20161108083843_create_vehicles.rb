class CreateVehicles < ActiveRecord::Migration[5.0]
  def change
    create_table :vehicles do |t|
      t.string :plate
      t.string :frame
      t.string :engine
      t.string :cityname
      t.integer :citycode

      t.timestamps
    end
  end
end
