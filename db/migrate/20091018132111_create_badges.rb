# -*- encoding : utf-8 -*-
class CreateBadges < ActiveRecord::Migration
  def self.up
    create_table :badges do |t|
      t.string :name
      t.integer :icon_id
      t.integer :level
      t.string :description
    end
    create_table :badges_characters do |t|
      t.integer :badge_id
      t.integer :character_id
      t.datetime :created_at
    end
    add_index :badges_characters,[ :badge_id,:character_id],:unique => true
  end

  def self.down
    drop_table :badges
    drop_table :badges_characters
  end
end
