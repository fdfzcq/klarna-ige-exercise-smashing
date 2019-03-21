require 'net/http'
require 'json'

# Constants used for api calls to get distance
GOOGLE_DISTANCEMATRIX_BASE_URL = 'https://maps.googleapis.com/maps/api/distancematrix/json'
API_KEY 	  = "" # TODO: fill in!
TRANSIT_MODES = %w(bus subway)
TRAVEL_MODES  = %w(driving walking bicycling) + TRANSIT_MODES

TRANSPORT_OPTIONS = %W(walking bicycling subway bus motor-cycle car-small car-medium)

# Grams of CO2 per passenger-km constants
CO2_PER_PASSENGER_BY_TRANSPORT_OPTIONS = {
	"walking" 	  => 0.0,
	"bicycling"   => 0.0,
	"subway"	  => 14.0,
	"bus" 		  => 68.0,
	"motor-cycle" => 72.0,
	"car-small"   => 104.0,
	"car-medium"  => 158.0
}

# Mapping transport options => transit mode
TRANSPORT_OPTION_TRANSIT_MODE_MAPPING = {
	"walking" 	  => "walking",
	"bicycling"   => "bicycling",
	"subway"	  => "subway",
	"bus" 		  => "bus",
	"motor-cycle" => "driving",
	"car-small"   => "driving",
	"car-medium"  => "driving"
}

def main
	SCHEDULER.every '180s' do
		# Locations in literal format
		from_address = "" # TODO: change me!
		to_address   = "" # TODO: change me!

		emission_max = 2000

		distances_and_durations = TRANSPORT_OPTIONS.map do |transport_option|
			result = get_travel_distance_and_duration(from_address, to_address, transport_option)
			# Calculate CO2 emission for the transport option and truncate the value to one digit after .
			co2_emission = estimate_co2_emission(result[:distance], transport_option).truncate(1).to_f
			# bonus TODO: set emission_max
			# emission_max = ?
			{
				emission: co2_emission,
			 	distance: result[:distance],
			 	transport_option: transport_option,
		     	duration: result[:duration]
		 	}
		end

		distances_and_durations.each do |res|
			emission_event = {
				value: res[:emission],
				max: emission_max
			}
			duration_event = {
				text: to_time(res[:duration])
			}

			send_event(res[:transport_option], emission_event)
			send_event(res[:transport_option] + '-duration', duration_event)
		end

		overview_event = {
			items: [
				{label: 'From', value: from_address},
				{label: 'To', value: to_address},
				# walking will always be 0
				{label: 'Min CO2', value: '0 g/person'}
				# bonus TODO: show 'MAX CO2'
			]
		}
		send_event('overview', overview_event)
	end
end

def get_travel_distance_and_duration(from_address, to_address, transport_option)
	# get the matching travel_mode from the transport_option_transit_mode map
	travel_mode = TRANSPORT_OPTION_TRANSIT_MODE_MAPPING[transport_option]
	# compose a uri like this:
	# https://maps.googleapis.com/maps/api/distancematrix/json?key=Key&origins=klarna+stockholm&destinations=fridhemsplan&mode=driving&transit_mode=nil
	travel_mode_query =
		TRANSIT_MODES.include?(travel_mode) ?
			'&mode=transit&transit_mode=' + travel_mode :
			'&mode=' + travel_mode
	uri = URI(GOOGLE_DISTANCEMATRIX_BASE_URL +
			'?key=' + API_KEY + '&origins=' +
			from_address + '&destinations=' +
			to_address + travel_mode_query)
	resp = Net::HTTP.get(uri)

	##	the response body would look like:
	##  { 
	##  		"destination_addresses" : [ "Fridhemsplan, 112 40 Stockholm, Sweden" ],
	##  		"origin_addresses" : [ "Sveavägen 46, 111 34 Stockholm, Sweden" ],
	##  		"rows" : [
	##     		{
	##        		"elements" : [
	##           		{
	##              			"distance" : {
	##                 				"text" : "4.1 km",
	##                 				"value" : 4146
	##              			},
	##              			"duration" : {
	##                 				"text" : "11 mins",
	##                 				"value" : 645
	##              			},
	##              			"status" : "OK"
	##           		}
	##        		]
	##     		}
	##   		],
	##   		"status" : "OK"
	##	}
	
	# parse the json response body and get information we need
	resp_json = JSON.parse(resp)["rows"].first["elements"].first
	# get the distance in km
	distance = resp_json["distance"]["value"]
	# get the duration in seconds
	duration = resp_json["duration"]["value"]
	# return a map of distance and duration
	{:distance => distance, :duration => duration}
end

def estimate_co2_emission(distance, mode)
	# Estimate CO2 emission by using data in
	# https://www.eea.europa.eu/media/infographics/carbon-dioxide-emissions-from-passenger-transport/view

	# get the amount of co2 emission (gram) per person per km from the CO2_PER_PASSENGER_BY_TRANSPORT_OPTIONS map

	# TODO: calculate CO2 emissions per person based on transport option
	co2_emission_per_person_km = ?
	co2_emission_per_person = ?

	return co2_emission_per_person
end

def to_time(sec)
	time_str = ""
	# convert seconds to literal time
	if (sec > 60 * 60)
		time_str = (sec / (60 * 60)).to_s + 'h '
		sec = sec % (60 * 60)
	end

	if (sec > 60)
		time_str = time_str + (sec / 60).to_s + 'm '
		sec = sec % 60
	end

	return time_str + sec.to_s + 's'
end

main
