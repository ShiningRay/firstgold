# -*- encoding : utf-8 -*-
class CreateMails < ActiveRecord::Migration
  def self.up
    create_table :mails do |t|
      t.integer :owner_id
      t.integer :sender_id
      t.integer :recipient_id
      t.text :content
      t.boolean :read
      t.text :attachment

      t.timestamps
    end
    add_index "mails", ["owner_id", "sender_id", "read"], :name => "owner_id"    
  end

  def self.down
    drop_table :mails
  end
end
