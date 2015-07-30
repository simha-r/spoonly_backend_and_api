# == Schema Information
#
# Table name: menu_products
#
#  id         :integer          not null, primary key
#  menu_id    :integer
#  product_id :integer
#  category   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class MenuProduct < ActiveRecord::Base
  belongs_to :menu
  belongs_to :product

  CATEGORIES = ['lunch','dinner']
  LUNCH_TIMES =['1200','1230','1330']
  DINNER_TIMES =['2100','2200','2230','2330']
  LUNCH_START_TIME=12
  DINNER_START_TIME=19


  def as_json
  end

  def self.show_lunch_times
    todays_menu = Menu.where(menu_date: Date.today).first
    if Time.now< todays_menu.lunch_order_end_time
      t = Time.now

      lunch_times = LUNCH_TIMES.reject do |lunch_time|
        t.strftime("%H%M") > lunch_time
      end
    else
      lunch_times = LUNCH_TIMES
    end
    lunch_times.collect { |hour| [Time.parse("#{hour[0..1]}:#{hour[2..3]}").strftime("%l:%M %P"),Time.parse("#{hour[0..1]}:#{hour[2..3]}").strftime("%l:%M %P")] }
  end

  def self.show_dinner_times
    todays_menu = Menu.where(menu_date: Date.today).first
    if Time.now< todays_menu.dinner_order_end_time
      t = Time.now

      dinner_times = DINNER_TIMES.reject do |dinner_time|
        t.strftime("%H%M") > dinner_time
      end
    else
      dinner_times = DINNER_TIMES
    end
    dinner_times.collect { |hour| [Time.parse("#{hour[0..1]}:#{hour[2..3]}").strftime("%l:%M %P"),Time.parse("#{hour[0..1]}:#{hour[2..3]}").strftime("%l:%M %P")] }
  end


end
