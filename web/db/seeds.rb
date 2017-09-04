# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
s = CottageTempSensor.find_or_create_by(name: "Main")
CottageTemp.find_or_create_by(temp: 79.9, timestamp: DateTime.now, cottage_temp_sensor: s)
CottageTemp.find_or_create_by(temp: 80.1, timestamp: DateTime.now + 1.0/(24*60*60), cottage_temp_sensor: s)