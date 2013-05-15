# -*- encoding : utf-8 -*-
class CreateShops < ActiveRecord::Migration
  def self.up
    create_table :shops do |t|
      t.string :name
      t.text :description
      t.integer :npc_id

      t.timestamps
    end
  end

  def self.down
    drop_table :shops
  end
end
