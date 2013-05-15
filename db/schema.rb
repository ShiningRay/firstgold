# -*- encoding : utf-8 -*-
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

ActiveRecord::Schema.define(:version => 20100511105903) do

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "answers", :force => true do |t|
    t.integer  "question_id",                :null => false
    t.integer  "user_id",     :default => 0, :null => false
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"
  add_index "answers", ["user_id"], :name => "index_answers_on_user_id"

  create_table "auctions", :force => true do |t|
    t.integer  "item_id",                           :null => false
    t.string   "item_type",     :default => "Item", :null => false
    t.integer  "seller_id",                         :null => false
    t.text     "description"
    t.integer  "upset_price",                       :null => false
    t.integer  "bid_increment"
    t.string   "status"
    t.datetime "expiration",                        :null => false
    t.integer  "bidder_id"
    t.integer  "final_price"
    t.integer  "buyout_price"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "badges", :force => true do |t|
    t.string  "name"
    t.integer "icon_id"
    t.integer "level"
    t.string  "description"
  end

  create_table "badges_characters", :force => true do |t|
    t.integer  "badge_id"
    t.integer  "character_id"
    t.datetime "created_at"
  end

  add_index "badges_characters", ["badge_id", "character_id"], :name => "index_badges_characters_on_badge_id_and_character_id", :unique => true

  create_table "bids", :force => true do |t|
    t.integer  "auction_id"
    t.integer  "bid_price"
    t.integer  "bidder_id"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "categories", :force => true do |t|
    t.string  "name",      :null => false
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
  end

  add_index "categories", ["lft", "rgt"], :name => "index_categories_on_lft_and_rgt"
  add_index "categories", ["name"], :name => "index_categories_on_name"
  add_index "categories", ["parent_id"], :name => "index_categories_on_parent_id"

  create_table "characters", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "lvl",        :default => 0, :null => false
    t.integer  "exp",        :default => 0, :null => false
    t.integer  "points",     :default => 0, :null => false
    t.integer  "str",        :default => 0, :null => false
    t.integer  "agi",        :default => 0, :null => false
    t.integer  "spr",        :default => 0, :null => false
    t.integer  "hp",         :default => 0, :null => false
    t.integer  "mp",         :default => 0, :null => false
    t.integer  "current_hp", :default => 0, :null => false
    t.integer  "current_mp", :default => 0, :null => false
    t.integer  "money",      :default => 0, :null => false
    t.string   "abilities"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "post_id",                   :null => false
    t.integer  "user_id",    :default => 0, :null => false
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["post_id"], :name => "index_comments_on_post_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "drops", :force => true do |t|
    t.integer  "npc_id",                          :null => false
    t.integer  "item_template_id",                :null => false
    t.integer  "quantity",         :default => 1, :null => false
    t.integer  "chance"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "drops", ["npc_id", "item_template_id"], :name => "index_drops_on_npc_id_and_item_template_id"

  create_table "formulas", :force => true do |t|
    t.string "name"
    t.text   "description"
    t.text   "input"
    t.text   "output"
  end

  create_table "icons", :force => true do |t|
    t.string   "name"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "item_templates", :force => true do |t|
    t.string   "name"
    t.integer  "price"
    t.string   "slot"
    t.integer  "max_stack"
    t.text     "extra"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
  end

  create_table "items", :force => true do |t|
    t.integer  "template_id"
    t.integer  "owner_id",                   :null => false
    t.integer  "quantity",    :default => 1, :null => false
    t.string   "in_slot"
    t.text     "extra"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "items", ["owner_id", "in_slot"], :name => "index_items_on_owner_id_and_in_slot"
  add_index "items", ["template_id"], :name => "item_template_id"

  create_table "mails", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.text     "content"
    t.boolean  "read"
    t.text     "attachment"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "mails", ["owner_id", "sender_id", "read"], :name => "owner_id"

  create_table "merchandises", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "item_template_id"
    t.integer  "price"
    t.integer  "limit"
    t.integer  "limit_duration"
    t.integer  "stock"
    t.integer  "shop_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "npcs", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "lvl"
    t.integer  "str"
    t.integer  "agi"
    t.integer  "spr"
    t.integer  "hp"
    t.integer  "mp"
    t.integer  "scenario_id"
    t.string   "abilities"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "posts", :force => true do |t|
    t.string   "title",      :null => false
    t.integer  "user_id",    :null => false
    t.text     "content",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "questions", :force => true do |t|
    t.integer  "user_id",     :default => 0,     :null => false
    t.string   "title",                          :null => false
    t.text     "content"
    t.integer  "category_id",                    :null => false
    t.boolean  "closed",      :default => false, :null => false
    t.boolean  "anonymous",   :default => false, :null => false
    t.boolean  "private",     :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["anonymous"], :name => "index_questions_on_anonymous"
  add_index "questions", ["category_id"], :name => "index_questions_on_category_id"
  add_index "questions", ["closed"], :name => "index_questions_on_closed"
  add_index "questions", ["private"], :name => "index_questions_on_private"
  add_index "questions", ["user_id"], :name => "index_questions_on_user_id"

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id", "user_id"], :name => "index_roles_users_on_role_id_and_user_id", :unique => true

  create_table "scenarios", :force => true do |t|
    t.integer  "owner_id"
    t.string   "name"
    t.string   "background_file_name"
    t.text     "description"
    t.string   "background_content_type"
    t.integer  "background_file_size"
    t.datetime "background_updated_at"
  end

  add_index "scenarios", ["owner_id"], :name => "index_scenarios_on_owner_id"

  create_table "shops", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "npc_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40,                         :null => false
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100,                        :null => false
    t.string   "crypted_password",          :limit => 40,                         :null => false
    t.string   "salt",                      :limit => 40,                         :null => false
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                    :default => "passive"
    t.datetime "deleted_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
  end

  add_index "users", ["activation_code"], :name => "index_users_on_activation_code", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["state"], :name => "index_users_on_state"

end
