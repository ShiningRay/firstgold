# -*- encoding : utf-8 -*-
class CreateItems < ActiveRecord::Migration
  def self.up
    create_table :items do |t|
      t.integer :template_id
      t.integer :owner_id, :null => false
      t.integer :quantity, :null => false, :default => 1
      t.string :in_slot
      t.text :extra
      t.timestamps
    end
    add_index :items, :template_id, :name => 'item_template_id'
    add_index :items, [:owner_id, :in_slot]

  end

  def self.down
    drop_table :items
  end
end
