# -*- encoding : utf-8 -*-
class Item < ActiveRecord::Base
  belongs_to :template, :class_name => 'ItemTemplate'
  belongs_to :owner, :class_name => 'Character', :foreign_key => 'owner_id'
  has_many :auctions, :as => :item
  serialize :extra
  
  def equipable?
    !slot.nil?
  end

  def after_initialize
    self.extra ||= {}
    #e = template ? template.extra : {} if self[:template_id]
    #self.extra.merge!(e) if e.is_a?(Hash)
    #self.extra.symbolize_keys!
  end

  def in_slot
    s = self[:in_slot]
    s and !s.blank? ? s.to_sym : nil
  end
  
  def slot
#    s = self[:slot]
#    s.nil? or s.blank? ? template.slot : s.to_sym
    template.slot
  end
  
  def name
    template.name
  end

  def template
    @template ||= ItemTemplate.find self[:template_id]
  end

  def refresh!
    template.generate(:level => extra[:level], :target=>self)
    save!
  end

  def hide!
    self.in_slot = :hidden
    self.save
  end

  def as_json(*args)
    r = attributes.as_json
    r['name']= name
    r['slot']= slot
    r
  end

#  def extra
#    template.extra
#  end

  before_save :clean_extra

  protected
  def clean_extra
    extra.each do |k,v|
      extra.delete(k) if not v or v.blank?
    end
    extra.symbolize_keys!
  end
#  def to_s
#    inspect
#  end
#  def inspect
#    attributes.inspect
#  end
end
