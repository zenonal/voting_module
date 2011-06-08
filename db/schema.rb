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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110605142757) do

  create_table "amendments", :force => true do |t|
    t.string   "name_en"
    t.text     "content_en"
    t.string   "name_fr"
    t.text     "content_fr"
    t.string   "name_nl"
    t.text     "content_nl"
    t.integer  "user_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "amendmentable_id"
    t.string   "amendmentable_type"
    t.integer  "validations_count",  :default => 0
  end

  create_table "arguments", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.boolean  "pro"
    t.integer  "argumentable_id"
    t.string   "argumentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "language"
    t.string   "title"
  end

  create_table "assignments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorships", :force => true do |t|
    t.integer  "politician_id"
    t.integer  "referendum_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bios", :force => true do |t|
    t.string   "bioable_type"
    t.integer  "bioable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content_fr"
    t.text     "content_nl"
    t.text     "content_en"
    t.string   "wiki_fr"
    t.string   "wiki_nl"
    t.string   "wiki_en"
  end

  create_table "categories", :force => true do |t|
    t.string   "name_fr"
    t.string   "name_en"
    t.string   "name_nl"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "language"
  end

  create_table "delegates", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delegations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "delegate_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exclusions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "excludable_id"
    t.string   "excludable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "initiatives", :force => true do |t|
    t.string   "name_en"
    t.text     "content_en"
    t.string   "name_fr"
    t.text     "content_fr"
    t.string   "name_nl"
    t.text     "content_nl"
    t.integer  "category_id"
    t.integer  "user_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "validations_count",  :default => 0
  end

  create_table "parties", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "politicians", :force => true do |t|
    t.string   "name"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "party_id"
  end

  create_table "referendums", :force => true do |t|
    t.string   "name_en"
    t.text     "content_en"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.text     "content_fr"
    t.text     "content_nl"
    t.string   "name_fr"
    t.string   "name_nl"
    t.integer  "category_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rpx_identifier"
    t.string   "displayName"
    t.string   "photo"
    t.integer  "party_id"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "validations", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "validable_type"
    t.integer  "validable_id"
  end

  create_table "votes", :force => true do |t|
    t.boolean  "vote",          :default => false
    t.integer  "voteable_id",                      :null => false
    t.string   "voteable_type",                    :null => false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["voteable_id", "voteable_type"], :name => "fk_voteables"
  add_index "votes", ["voter_id", "voter_type"], :name => "fk_voters"

end
