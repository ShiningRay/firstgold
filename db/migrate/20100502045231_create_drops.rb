# -*- encoding : utf-8 -*-
class CreateDrops < ActiveRecord::Migration
  def self.up
    create_table :drops do |t|
      t.integer :npc_id, :null => false
      t.integer :item_template_id, :null => false
      t.integer :quantity, :null => false, :default => 1
      t.integer :chance

      t.timestamps
    end
    add_index :drops, [:npc_id, :item_template_id]
  end

  def self.down
    drop_table :drops
  end
end
