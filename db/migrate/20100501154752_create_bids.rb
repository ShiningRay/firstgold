class CreateBids < ActiveRecord::Migration
  def self.up
    create_table :bids do |t|
      t.integer :auction_id
      t.integer :bid_price
      t.integer :bidder_id
      t.string :status

      t.timestamps
    end
    
  end

  def self.down
    drop_table :bids
  end
end
