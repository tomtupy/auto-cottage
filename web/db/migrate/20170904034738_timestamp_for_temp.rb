class TimestampForTemp < ActiveRecord::Migration[5.0]
  def change
  	add_column :cottage_temps, :timestamp, :datetime
  end
end
