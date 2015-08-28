class SitemapsController < ApplicationController
  def show
    redirect_to "http://s3-ap-southeast-1.amazonaws.com/#{ENV['S3_BUCKET_NAME']}/sitemaps/sitemap.xml.gz"
  end
end