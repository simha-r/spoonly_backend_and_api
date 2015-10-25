require 'heroku-api'

namespace :heroku do

  task :scale_up => :environment do
    todays_date = Time.now.to_date
    return if todays_date.saturday? || todays_date.sunday?

    heroku = Heroku::API.new
    heroku.post_ps_scale(ENV["HEROKU_APP_NAME"], 'web', ENV['HEROKU_WEB_HIGH'])
  end

  task :scale_down => :environment do
    heroku = Heroku::API.new
    heroku.post_ps_scale(ENV["HEROKU_APP_NAME"], 'web', ENV['HEROKU_WEB_LOW'])
  end


end
