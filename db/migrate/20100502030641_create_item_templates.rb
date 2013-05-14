class CreateItemTemplates < ActiveRecord::Migration
  def self.up
    create_table :item_templates do |t|
      t.string :name
      t.integer :price
      t.string :slot
      t.integer :max_stack
      t.text :extra

      t.timestamps
    end
  end

  def self.down
    drop_table :item_templates
  end
end
