# -*- encoding : utf-8 -*-
class Auction < ActiveRecord::Base
  belongs_to :seller, :class_name => 'Character'
  has_many :bids
  belongs_to :item, :polymorphic => true
#  include AASM
  def close
    raise 'Error' if status != 'open'
    self.status = 'closed'
  end
  def expire
    raise 'Error' if status != 'open'
    self.status = 'expired'
  end
  def cancel
    raise 'Error' if status != 'open'
    self.status = 'canceled'
  end

  def self.setup(item, upset_price, expiration, buyout_price = nil)
    transaction :requires_new => true do
      item.lock!
      item.hide!
      item.save!
      auction = create :item => item,
        :seller => item.owner,
        :upset_price => upset_price,
        :expiration => expiration,
        :buyout_price => buyout_price
    end
  end

  def buyout(buyer)
    transaction do
      self.lock!
      buyer.lock!
      item.lock!
      seller.lock!

      buyer.money -= buyout_price
      buyer.save!

      #TODO: write transaction logs
      #TODO: send mail with money to the seller instead of directly manipulate its balance
      seller.money += buyout_price
      seller.save!
      
      item.owner = buyer
      item.save!
      
      close
      save!
    end
  end
end
