
var CottageApp = angular.module('CottageApp', ['restangular', "highcharts-ng"])


/* =====================================
 * =====  COTTAGE TEMP CONTROLLER  =====
 * =====================================
 */
CottageApp.controller('CottageNgController', function($scope, $http, Restangular, $timeout) {
  var cottage_controller = this;
 
  /*
   * Helpers
   */
  cottage_controller.get_current_timestamp = function()
  {
    return Math.floor((new Date()).getTime() / 1000);
  }

  cottage_controller.chartConfig = {
      chart: {
        type: 'line'
      },
      series: [{
        data: [],
        id: 'main_temp_series'
      }],
      title: {
        text: 'Hello'
      },
      xAxis: [{
        type: 'datetime',
        dateTimeLabelFormats: { // don't display the dummy year
            day: '%d %b %Y',
            month: '%e. %b',
            year: '%b'
        },
        title: {
            text: 'Date'
        }
      }],
      yAxis: [{ // Primary yAxis
        title: {
          text: 'number of notification',
        }
      }],
      plotOptions: {
        line: {
            marker: {
                enabled: true
            }
        }
    },
    }

  cottage_controller.update_cottage_temps = function(incremental_only) {
    Restangular.all("cottage").customGET("get_cottage_temps", {incremental_only: incremental_only, last_timestamp: cottage_controller.last_temp_timestamp}, {}).then(
      function(temp_data) {
        console.log(temp_data);
        cottage_controller.clock = temp_data.current_datetime;
        var parsed_data = _.each(temp_data.temp_data, function(temp_point) {
          return [new Date(temp_point[0]).getUTCDate(), temp_point[1]];
        });

        if (incremental_only) {
          _.each(parsed_data, function(temp_point) {
            cottage_controller.chartConfig.series[0].data.push([temp_point[0], temp_point[1]]);
          });
        } else {
          cottage_controller.chartConfig.series[0].data = parsed_data;
        }
        cottage_controller.last_temp_timestamp = _.last(parsed_data)[0];
      }
    );
  }

  cottage_controller.clock = "loading clock..."; // initialise the time variable
  cottage_controller.tickInterval = 1000 //ms
  cottage_controller.poll_interval = 7; //seconds
  cottage_controller.cottage_temps_last_update = cottage_controller.get_current_timestamp();
  cottage_controller.last_temp_timestamp = null;

  var tick = function() {
      var timediff = cottage_controller.get_current_timestamp() - cottage_controller.cottage_temps_last_update;
      console.log(timediff);
      cottage_controller.cottage_temps_seconds_since_update = (isNaN(timediff) ? 0 : timediff);
      if (cottage_controller.cottage_temps_seconds_since_update > cottage_controller.poll_interval) {

        // Update graph
        cottage_controller.update_cottage_temps(true);
        cottage_controller.cottage_temps_last_update = cottage_controller.get_current_timestamp();
      }

      $timeout(tick, cottage_controller.tickInterval); // reset the timer
  }

  // Update temps when page loads
  cottage_controller.update_cottage_temps(false);

  // Start the timer
  $timeout(tick, cottage_controller.tickInterval);

});