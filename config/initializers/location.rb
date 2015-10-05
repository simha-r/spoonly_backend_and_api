#TODO Storing the border_patrol serving area in application config..so that we dont need to parse the file on each
# request
file = File.read('data/serving_area_5_oct.kml')
Rails.application.config.serving_region = BorderPatrol.parse_kml(file)
puts "Initialized serving region"
