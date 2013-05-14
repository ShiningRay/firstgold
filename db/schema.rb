# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081129151026) do

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

  create_table "categories", :force => true do |t|
    t.string  "name",      :null => false
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
  end

  add_index "categories", ["lft", "rgt"], :name => "index_categories_on_lft_and_rgt"
  add_index "categories", ["name"], :name => "index_categories_on_name"
  add_index "categories", ["parent_id"], :name => "index_categories_on_parent_id"

  create_table "comments", :force => true do |t|
    t.integer  "post_id",                   :null => false
    t.integer  "user_id",    :default => 0, :null => false
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["post_id"], :name => "index_comments_on_post_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

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

  add_index "roles", ["name"], :name => "index_roles_on_name", :unique => true

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id", :default => 0, :null => false
    t.integer "user_id", :default => 0, :null => false
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

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
  end

  add_index "users", ["activation_code"], :name => "index_users_on_activation_code", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["state"], :name => "index_users_on_state"

end
