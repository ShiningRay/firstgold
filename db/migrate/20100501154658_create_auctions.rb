# -*- encoding : utf-8 -*-
class CreateAuctions < ActiveRecord::Migration
  def self.up
    create_table :auctions do |t|
      t.integer :item_id, :null => false
      t.string :item_type, :null => false, :default => 'Item'
      t.integer :seller_id, :null => false
      t.text :description
      t.integer :upset_price, :null => false
      t.integer :bid_increment
      t.string :status
      t.datetime :expiration, :null => false
      t.integer :bidder_id
      t.integer :final_price
      t.integer :buyout_price
      t.timestamps
    end
  end

  def self.down
    drop_table :auctions
  end
end
