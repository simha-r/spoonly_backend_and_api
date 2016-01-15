#Storing the border_patrol serving area in application config..so that we dont need to parse the file on each
# request
file = File.read('data/serving_area_jan_15th.kml')
dinner_file = File.read('data/serving_area_jan_15th.kml')
Rails.application.config.serving_region = BorderPatrol.parse_kml(file)
Rails.application.config.lunch_serving_region = BorderPatrol.parse_kml(file)
Rails.application.config.dinner_serving_region = BorderPatrol.parse_kml(dinner_file)
puts "Initialized serving region"
