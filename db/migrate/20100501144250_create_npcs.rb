# -*- encoding : utf-8 -*-
class CreateNpcs < ActiveRecord::Migration
  def self.up
    create_table :npcs do |t|
      t.string :name
      t.text :description
      t.integer :lvl
      t.integer :str
      t.integer :agi
      t.integer :spr
      t.integer :hp
      t.integer :mp
      t.integer :scenario_id
      t.string :abilities
      t.timestamps
    end
  end

  def self.down
    drop_table :npcs
  end
end
