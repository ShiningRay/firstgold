class CreateMerchandises < ActiveRecord::Migration
  def self.up
    create_table :merchandises do |t|
      t.string :name
      t.text :description
      t.integer :item_template_id
      t.integer :price
      t.integer :limit
      t.integer :limit_duration
      t.integer :stock
      t.integer :shop_id

      t.timestamps
    end
  end

  def self.down
    drop_table :merchandises
  end
end
