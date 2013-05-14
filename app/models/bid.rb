class Bid < ActiveRecord::Base
  belongs_to :auction
  belongs_to :bidder, :class_name => 'Character'

end
