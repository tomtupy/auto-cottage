require 'sqlite3'
require 'date'

db = SQLite3::Database.new('web/db/development.sqlite3')

output = `modprobe w1-gpio`
output = `modprobe w1-therm`

@temp_sensor = "testfile"

def temp_raw
  lines = []
  File.open(@temp_sensor, "r") do |f|
    f.each_line do |line|
      lines << line
    end
  end
  lines
end

def read_temp
  lines = temp_raw()
  while lines[0].strip().split(//).last(3).join != "YES"
    sleep(0.2)
    lines = temp_raw()
  end
  if lines[1].include?("t=")
    temp_string = lines[1].split("t=").last
    temp_c = temp_string.to_f / 1000.0
    temp_f = temp_c * 9.0 / 5.0 + 32.0
    return temp_f
  end
end

while true
  temp_f = read_temp
  current_dt = Time.parse(DateTime.now.to_s).utc
  current_dt = "#{current_dt}".gsub!("UTC" ,"").strip() + ".000000"
  db.execute("INSERT INTO cottage_temps(temp,cottage_temp_sensor_id,timestamp,created_at,updated_at) VALUES(#{temp_f}, #{1}, '#{current_dt}', '#{current_dt}', '#{current_dt}')")
  sleep(10)
end