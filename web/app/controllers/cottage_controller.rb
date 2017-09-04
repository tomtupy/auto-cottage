class CottageController < ApplicationController
  def index
    @current_dt = DateTime.now
    @temps = CottageTemp.all
  end

  def get_cottage_temps
    options = params.permit(:incremental_only, :last_timestamp)

    sensor = CottageTempSensor.first
    temp_data = []
    if options["incremental_only"].to_bool
      p DateTime.parse(options["last_timestamp"]).utc
      temp_data = sensor.cottage_temps.where("timestamp > ?", DateTime.parse(options["last_timestamp"]) + 1.second).order('timestamp ASC').map{|t| [t.timestamp, t.temp]}
    else
      temp_data = sensor.cottage_temps.where(timestamp: 3.hours.ago..DateTime.now).order('timestamp ASC').map{|t| [t.timestamp, t.temp]}
    end
    render json: {  :status_code => 1, :current_datetime => DateTime.now, :new_temp => Random.rand(100), :temp_data => temp_data }
  end
end
