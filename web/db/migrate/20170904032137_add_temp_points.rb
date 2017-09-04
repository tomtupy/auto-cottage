class AddTempPoints < ActiveRecord::Migration[5.0]
  def change
    create_table :cottage_temps do |t|
      t.float :temp
      t.belongs_to :cottage_temp_sensor

      t.timestamps null: false
    end

    create_table :cottage_temp_sensors do |t|
      t.string :name
      t.string :description
    end
  end
end
