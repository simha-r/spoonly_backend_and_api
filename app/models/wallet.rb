# == Schema Information
#
# Table name: wallets
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  balance    :float            default(0.0)
#  created_at :datetime
#  updated_at :datetime
#

class Wallet < ActiveRecord::Base
  belongs_to :user
  has_many :card_transactions
  has_many :credits
  has_many :debits

  validates_presence_of :user

  def add_card_amount amount,payment_id,payment_gateway
    amount = amount.to_f
    new_balance = self.balance.to_f + amount
    card_transaction = CardTransaction.create!(amount: amount,transaction_id: payment_id,
                                               payment_gateway: payment_gateway)
    if card_transaction.create_credit(amount: amount,credit_type: 'card',latest_wallet_balance: new_balance,
                                      wallet: self)
      update_attributes!(balance: new_balance)
    end
  end

  def debit_amount_for_order order
    debit_amount = (order.grand_total >= balance ? balance : order.grand_total )
    if debit_amount > 0
      new_balance = self.balance.to_f - debit_amount.to_f
      if debits.create(amount: debit_amount,order_id: order.id,latest_wallet_balance: new_balance)
        update_attributes!(balance: new_balance)
      end
    end
  end

  def apply_promotion wallet_promotion
    amount = wallet_promotion.amount.to_f
    new_balance = self.balance.to_f + amount
    if wallet_promotion.credits.create!(amount: amount,credit_type: 'promotion',
                                       latest_wallet_balance: new_balance,wallet: self)
      update_attributes!(balance: new_balance)
    else
      return false
    end
  end

  def refund_cancelled_order order
    if order.prepaid_amount > 0
      credit_amount = order.prepaid_amount
      new_balance = self.balance.to_f + credit_amount
      cancellation_refund = Refund.first_or_create(name: 'cancellation')
      cancellation_refund.credits.create(amount: credit_amount,credit_type: 'refund',wallet: self,
                                         latest_wallet_balance: new_balance)
      update_attributes(balance: new_balance)
    end
  end

  def clear_out!
    new_balance = balance - balance
    special_debit=debits.new(amount: balance,latest_wallet_balance: new_balance)
    if  special_debit.save(validate: false)
      update_attributes!(balance: new_balance)
    end
  end

  def recharge_link
    if user.profile.phone_number.present?
      "https://www.instamojo.com/Spoonly/spoonly-wallet-recharge-04b9d/?embed=form&data_hidden=data_Field_96618&data_readonly=data_name&data_readonly=data_email&data_readonly=data_phone&data_readonly=data_amount&data_email=#{user.email}&data_name=#{user.name[0..18]}&data_phone=#{user.profile.phone_number}&intent=buy&data_Field_96618=#{user.id}&data_amount="
    else
      "https://www.instamojo.com/Spoonly/spoonly-wallet-recharge-04b9d/?embed=form&data_hidden=data_Field_96618&data_readonly=data_name&data_readonly=data_email&data_readonly=data_amount&data_email=#{user.email}&data_name=#{user.name[0..18]}&intent=buy&data_Field_96618=#{user.id}&data_amount="
    end
  end

  def serializable_hash(options={})
    options||={}
    options[:except]=[:created_at,:updated_at,:id,:user_id]
    options[:methods]=[:recharge_link]
    super
  end


end




#https://www.instamojo.com/Spoonly/spoonly-wallet-recharge-40e3a/?embed=form&data_hidden=data_Field_35054&data_readonly=data_name&data_readonly=data_email&data_readonly=data_phone&data_readonly=data_amount&data_email=simhaece@gmail.com&data_name=Narasimha%20Reddy&data_phone=8179422804&intent=buy&data_Field_35054=15
#https://www.instamojo.com/Spoonly/spoonly-wallet-recharge-rs-200/?embed=form&data_hidden=data_Field_35054&data_readonly=data_name&data_readonly=data_email&data_readonly=data_phone&data_readonly=data_amount&data_email=simhaece@gmail.com&data_name=Narasimha%20Reddy&data_phone=8179422804&intent=buy&data_Field_35054=15
#https://www.instamojo.com/Spoonly/spoonly-wallet-recharge-400/?embed=form&data_hidden=data_Field_35054&data_readonly=data_name&data_readonly=data_email&data_readonly=data_phone&data_readonly=data_amount&data_email=simhaece@gmail.com&data_name=Narasimha%20Reddy&data_phone=8179422804&intent=buy&data_Field_35054=15

#https://www.instamojo.com/Spoonly/spoonly-wallet-recharge-rs-200/?embed=form&data_hidden=data_Field_35054&data_readonly=data_name&data_readonly=data_email&data_readonly=data_phone&data_readonly=data_amount&data_email=simhaece@gmail.com&data_name=Narasimha%20Reddy&data_phone=8179422804&intent=buy&data_Field_35054=15


#For android..use the below link for Rs 200
#https://www.instamojo.com/Spoonly/spoonly-wallet-recharge-04b9d/?embed=form&data_hidden=data_Field_96618&data_readonly=data_name&data_readonly=data_email&data_readonly=data_phone&data_readonly=data_amount&data_email=simhaece@gmail.com&data_name=Narasimha%20Reddy&data_phone=8179422804&intent=buy&data_Field_96618=15&data_amount=200