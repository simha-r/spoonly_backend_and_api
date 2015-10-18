# == Schema Information
#
# Table name: menu_products
#
#  id           :integer          not null, primary key
#  menu_id      :integer
#  product_id   :integer
#  category     :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  max_quantity :integer
#  sold_out     :boolean          default(FALSE)
#

class MenuProduct < ActiveRecord::Base
  belongs_to :menu
  belongs_to :product

  CATEGORIES = ['lunch','dinner']
  LUNCH_TIMES ={'1200'=>'12-12:30 PM','1230'=>'12:30-1:00 PM','1300'=>'1:00-1:30 PM','1330'=>'1:30-2:00 PM',
                '1400'=>'2-2:30 PM','1430'=>'2:30-3:00 PM','1500'=>'3-3:30 PM','1530'=>'3:30-4:00 PM',
                '1600'=>'4:00-4:30 PM'}

  DINNER_TIMES ={'1930'=>'7:30-8:00 PM','2000'=>'8:00-8:30 PM','2030'=>'8:30-9:00 PM','2100'=>'9:00-9:30 PM',
                 '2130'=>'9:30-10:00 PM',
                 '2200'=>'10-10:30 PM'}
  LUNCH_START_TIME=13
  DINNER_START_TIME=19
  MAX_QUANTITIES=[20,30,40,50,60,70,80]

  validates :product_id, :uniqueness => {:scope => [:menu_id,:category]}


  def as_json
  end

  def self.show_lunch_times
    todays_menu = Menu.where(menu_date: Date.current).first
    if Time.now< todays_menu.lunch_order_end_time
      t = Time.now

      lunch_times = LUNCH_TIMES.reject do |lunch_time,lunch_range|
        t.strftime("%H%M") > lunch_time
      end
    else
      lunch_times = LUNCH_TIMES
    end
    lunch_times.collect do |hour,range|
      [Time.parse("#{hour[0..1]}:#{hour[2..3]}").strftime("%l:%M %P"),range]
    end

  end

  def self.show_all_lunch_times
    MenuProduct::LUNCH_TIMES.collect do |hour,range|
      [Time.parse("#{hour[0..1]}:#{hour[2..3]}").strftime("%l:%M %P"),range]
    end
  end

  def self.show_dinner_times
    todays_menu = Menu.where(menu_date: Date.current).first
    if Time.now< todays_menu.dinner_order_end_time
      t = Time.now

      dinner_times = DINNER_TIMES.reject do |dinner_time,range|
        t.strftime("%H%M") > dinner_time
      end
    else
      dinner_times = DINNER_TIMES
    end
    dinner_times.collect { |hour,range| [Time.parse("#{hour[0..1]}:#{hour[2..3]}").strftime("%l:%M %P"),
                                    range] }
  end


end
