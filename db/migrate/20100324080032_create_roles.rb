# -*- encoding : utf-8 -*-
class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table "roles", :force => true do |t|
      t.string :name
    end
    
    # generate the join table
    create_table "roles_users", :id => false, :force => true do |t|
      t.integer "role_id", "user_id"
    end
    add_index "roles_users", ["role_id", "user_id"], :unique => true
  end

  def self.down
    drop_table "roles"
    drop_table "roles_users"
  end
end
