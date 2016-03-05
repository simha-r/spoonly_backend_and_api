# == Schema Information
#
# Table name: menus
#
#  id                       :integer          not null, primary key
#  menu_date                :date
#  created_at               :datetime
#  updated_at               :datetime
#  lunch_notification_sent  :boolean          default(FALSE)
#  dinner_notification_sent :boolean
#

class Menu < ActiveRecord::Base

  has_many :menu_products
  has_many :products,through: :menu_products


  has_many :menu_lunch_products,-> { where(menu_products: {category: 'lunch'}) }, class_name: 'MenuProduct'
  has_many :menu_dinner_products,-> { where(menu_products: {category: 'dinner'}) }, class_name: 'MenuProduct'

  has_many :lunch_products, -> { where(menu_products: {category: 'lunch'}) },
           :through => :menu_products, source: :product


  has_many :dinner_products, -> { where(menu_products: {category: 'dinner'}) },
           :through => :menu_products, source: :product


  def self.today
    where(menu_date: Date.current).first
  end

  def self.tomorrow
    where(menu_date: Date.tomorrow).first
  end

  def self.current_lunch
    if today
      if Time.now < today.lunch_order_end_time
        today
      else
        tomorrow
      end
    else
      tomorrow
    end
  end

  def self.current_dinner
    if today
      if Time.now < today.dinner_order_end_time
        today
      else
        tomorrow
      end
    else
      tomorrow
    end
  end

  def show_lunch
    hash = {start_time: lunch_start_time, end_time: lunch_end_time,end_order_time: lunch_order_end_time,

    products: menu_lunch_products.order(:created_at).includes(:product).collect{|menu_product| menu_product.product.as_json.merge(menu_product_id: menu_product.id,sold_out: menu_product.sold_out)}}
    hash = {notice: 'No Products available today'} if !menu_lunch_products.present?
    hash[:referral_text] = "<html><body>Earn Free Meals<br />Give &#8377 50, Get &#8377 50</body></html>"
    hash[:timings]=["12:00 PM - 12:30 PM","12:30 PM - 01:00 PM","01:00 PM - 01:30 PM","01:30 PM - 02:00 PM",
                    "02:00 PM - 02:30 PM","02:30 PM - 03:00 PM","03:00 PM - 03:30 PM"]
    hash[:buffer_time]=ENV['BUFFER_TIME'].to_i
    hash
  end

  def show_dinner
    hash = {start_time: dinner_start_time, end_time: dinner_end_time,end_order_time: dinner_order_end_time,
                     products: menu_dinner_products.order(:created_at).includes(:product).collect{|menu_product| menu_product.product.as_json.merge(menu_product_id: menu_product.id,sold_out: menu_product.sold_out)}}
    hash = {notice: 'No Products available today'} if !menu_dinner_products.present?
    hash[:referral_text] = "<html><body>Earn Free Meals<br />Give &#8377 50, Get &#8377 50</body></html>"
    hash[:timings]=["07:15 PM - 08:00 PM","08:00 PM - 08:45 PM","08:45 PM - 09:30 PM","09:30 PM - 10:15 PM",
                    "10:15 PM - 11:00 PM"]
    hash[:buffer_time]=ENV['BUFFER_TIME'].to_i
    hash
  end

  def lunch_start_time
    Time.zone.local(menu_date.year,menu_date.month,menu_date.day,MenuProduct::LUNCH_START_TIME,0,0)
  end

  def lunch_end_time
    lunch_start_time+3.5.hours
  end

  def lunch_order_end_time
    lunch_end_time - 0.5.hour
  end

  def dinner_start_time
    Time.zone.local(menu_date.year,menu_date.month,menu_date.day,MenuProduct::DINNER_START_TIME,15,0)
  end
  def dinner_end_time
    dinner_start_time+225.minutes
  end

  def dinner_order_end_time
    dinner_end_time - 45.minutes
  end

  def notify_users_lunch title,message
    update_attributes(lunch_notification_sent: true)
    users = User.all - Order.today.where(category: 'lunch').collect(&:user)
    users.each do |u|
      u.notify_menu message,title
    end
  end


  def notify_users_dinner title,message
    update_attributes(dinner_notification_sent: true)
    users = User.all - Order.today.where(category: 'dinner').collect(&:user)
    users.each do |u|
      u.notify_menu message,title
    end
  end


end
