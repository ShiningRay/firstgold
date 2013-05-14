class Shop < ActiveRecord::Base
  has_many :merchandises
  belongs_to :npc


end
