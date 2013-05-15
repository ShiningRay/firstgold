# -*- encoding : utf-8 -*-
class AddAttachmentsBackgroundToScenarios < ActiveRecord::Migration
  def self.up
    rename_column :scenarios, :background, :background_file_name
    add_column :scenarios, :background_content_type, :string
    add_column :scenarios, :background_file_size, :integer
    add_column :scenarios, :background_updated_at, :datetime
  end

  def self.down
    rename_column :scenarios, :background_file_name, :background
    remove_column :scenarios, :background_content_type
    remove_column :scenarios, :background_file_size
    remove_column :scenarios, :background_updated_at
  end
end
