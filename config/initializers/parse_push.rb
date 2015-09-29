require 'parse-ruby-client'
Parse.init :application_id =>ENV["PARSE_APPLICATION_ID"], # required
           :api_key        => ENV["PARSE_API_KEY"]