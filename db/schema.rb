# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150826140338) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
    t.string   "address_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "company"
    t.string   "floor"
    t.string   "building"
    t.string   "flat"
    t.string   "landmark"
    t.string   "address_details"
    t.boolean  "is_default",      default: false
  end

  create_table "authorizations", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.string   "token"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "card_transactions", force: true do |t|
    t.string   "transaction_id"
    t.string   "amount"
    t.string   "payment_gateway"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "card_transactions", ["transaction_id", "payment_gateway"], name: "index_card_transactions_on_transaction_id_and_payment_gateway", unique: true, using: :btree

  create_table "carts", force: true do |t|
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "menu_id"
    t.datetime "expiry_time"
  end

  create_table "company_users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                     default: "", null: false
    t.string   "encrypted_password",        default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "encrypted_otp_secret"
    t.string   "encrypted_otp_secret_iv"
    t.string   "encrypted_otp_secret_salt"
    t.boolean  "otp_required_for_login"
    t.string   "phone_number"
    t.string   "otp_backup_codes",                                    array: true
  end

  add_index "company_users", ["email"], name: "index_company_users_on_email", unique: true, using: :btree
  add_index "company_users", ["reset_password_token"], name: "index_company_users_on_reset_password_token", unique: true, using: :btree

  create_table "company_users_roles", id: false, force: true do |t|
    t.integer "company_user_id"
    t.integer "role_id"
  end

  add_index "company_users_roles", ["company_user_id", "role_id"], name: "index_company_users_roles_on_company_user_id_and_role_id", using: :btree

  create_table "credits", force: true do |t|
    t.integer  "wallet_id"
    t.float    "amount"
    t.string   "latest_wallet_balance"
    t.string   "credit_type"
    t.integer  "payment_mechanism_id"
    t.string   "payment_mechanism_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "credits", ["wallet_id"], name: "index_credits_on_wallet_id", using: :btree

  create_table "debits", force: true do |t|
    t.integer  "wallet_id"
    t.float    "amount"
    t.string   "latest_wallet_balance"
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "debits", ["order_id"], name: "index_debits_on_order_id", using: :btree
  add_index "debits", ["wallet_id"], name: "index_debits_on_wallet_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "delivery_executives", force: true do |t|
    t.string   "name"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedbacks", force: true do |t|
    t.integer  "overall_rating"
    t.string   "comment"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "line_items", force: true do |t|
    t.string   "product_name"
    t.integer  "menu_product_id"
    t.integer  "order_id"
    t.integer  "cart_id"
    t.float    "price"
    t.integer  "quantity",        default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menu_products", force: true do |t|
    t.integer  "menu_id"
    t.integer  "product_id"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "max_quantity"
  end

  add_index "menu_products", ["menu_id"], name: "index_menu_products_on_menu_id", using: :btree
  add_index "menu_products", ["product_id"], name: "index_menu_products_on_product_id", using: :btree

  create_table "menus", force: true do |t|
    t.date     "menu_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.datetime "delivery_time"
    t.string   "state"
    t.string   "pay_type"
    t.integer  "address_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "category"
    t.integer  "delivery_executive_id"
  end

  create_table "products", force: true do |t|
    t.string   "name"
    t.string   "desc"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "vegetarian",         default: false
  end

  create_table "profiles", force: true do |t|
    t.string   "name"
    t.string   "phone_number"
    t.boolean  "phone_number_verified",          default: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number_verification_code"
    t.integer  "phone_number_verify_tries"
    t.string   "pic_url"
  end

  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "referrals", force: true do |t|
    t.integer  "referrer_id"
    t.integer  "referred_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "referrals", ["referrer_id", "referred_id"], name: "index_referrals_on_referrer_id_and_referred_id", unique: true, using: :btree

  create_table "refunds", force: true do |t|
    t.string   "description"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "users", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "authentication_token"
    t.string   "referral_code"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "wallet_promotions", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.float    "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wallets", force: true do |t|
    t.integer  "user_id"
    t.float    "balance",    default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wallets", ["user_id"], name: "index_wallets_on_user_id", using: :btree

end
