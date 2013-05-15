# -*- encoding : utf-8 -*-
class Badge < ActiveRecord::Base
  belongs_to :icon
  has_and_belongs_to_many :characters
#  key :name, String, :required => true, :unique => true
#  key :description, String
end
