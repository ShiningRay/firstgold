class CreateIcons < ActiveRecord::Migration
  def self.up
    create_table :icons do |t|
      t.string :name
      t.string :icon_file_name
      t.string :icon_content_type
      t.integer :icon_file_size
      t.timestamps
    end
  end

  def self.down
    drop_table :icons
  end
end
