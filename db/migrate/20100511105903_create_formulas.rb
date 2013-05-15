# -*- encoding : utf-8 -*-
class CreateFormulas < ActiveRecord::Migration
  def self.up
    create_table :formulas do |t|
        t.column :name, :string
        t.column :description, :text
        t.column :input, :text
        t.column :output, :text
    end
  end

  def self.down
    drop_table :formulas
  end
end
