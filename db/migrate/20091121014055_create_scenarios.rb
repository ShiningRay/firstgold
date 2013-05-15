# -*- encoding : utf-8 -*-
class CreateScenarios < ActiveRecord::Migration
  def self.up
    create_table :scenarios, :id => false do |t|
      t.integer :id, :options => 'PRIMARY KEY', :null => false, :default => 0
      t.integer :owner_id
      t.string :name
      t.string :background
      t.text :description
    end
    execute "ALTER TABLE  `scenarios` ADD PRIMARY KEY (  `id` )"
    add_index :scenarios, :owner_id
  end

  def self.down
    drop_table :scenarios
  end
end
