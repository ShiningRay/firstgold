class Merchandise < ActiveRecord::Base
#  belongs_to :item, :class_name => 'ItemTemplate', :foreign_key => 'item_id'
  belongs_to :item_template
  belongs_to :shop

  def price
    self[:price] || item_template.price
  end

  def name
    self[:name] or self[:name].blank? ? item_template.name : self[:name]
  end

  def has_stock?
    not stock or stock > 0
  end

  def decr_stock num = 1
    return unless stock
    self.stock -= num
  end
end
