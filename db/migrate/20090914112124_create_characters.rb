# -*- encoding : utf-8 -*-
class CreateCharacters < ActiveRecord::Migration
  def self.up
    create_table :characters do |t|
      t.string :name
      t.integer :user_id
      %w(lvl exp points
        str agi spr
        hp mp
        current_hp current_mp
        money
      ).each do |f|
        t.integer f, :null => false, :default => 0
      end
      t.string :abilities
      t.timestamps
    end
  end

  def self.down
    drop_table :characters
  end
end
