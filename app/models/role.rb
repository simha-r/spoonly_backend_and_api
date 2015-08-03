class Role < ActiveRecord::Base
  has_and_belongs_to_many :company_users, :join_table => :company_users_roles
  belongs_to :resource, :polymorphic => true
  
  scopify
end
