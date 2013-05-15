# -*- encoding : utf-8 -*-
# ItemTemplate is the meta-data for items
Properties = {
  1 => {:str => 10},
  2 => {:spr => 10},
  3 => {:agi => 1},
  4 => {:agi => 10}
}
class ItemTemplate < ActiveRecord::Base
  has_many :items, :foreign_key => 'template_id'
  serialize :extra
  include IdentityMap
  has_attached_file :icon,
                    :styles => {:medium => "100x100>",
                                :thumb => "32x32#"},
                    :default_url => "/images/413.gif"
  def after_initialize
    self.extra ||= {}
  end

  def generate(opt={})
    result_item = opt[:target] || items.build
    
    if Character::EquipmentSlots.include?(slot.to_sym)
      level = max_level = extra[:max_level].to_i
      if opt[:level]
        level = opt[:level]
      else
        if opt[:upper_level]
          ul = opt[:upper_level]
          ll = opt[:lower_level].to_i
          level = [rand(ul-ll)+ll, max_level].min
        end
      end
      return result_item if level == 0
      quality = (level - extra[:ref_level]) / 3
      properties = []
      max_rand = quality * 2 
      rest_level = level
      i = 0 
      candidates = extra[:candidates].to_a.shuffle
      while i<max_rand and properties.size < quality
        i+=1
        break unless candidates.size > 0
        prop_id, weight = candidates.pop
        next unless rest_level > weight
        rest_level -= weight
        properties << Properties[prop_id]
      end
      
      stats = {}
      
      for p in properties
        for k,v in p
          stats[k] = stats[k] ?  stats[k]+v : v
        end
      end
      
      result_item.extra[:level] = level
      result_item.extra[:stats] = stats  
    end
    result_item
  end

  def slot
    s = self[:slot]
    s && !s.blank? ? s.to_sym : nil
  end
  
  before_save :clean_extra

  protected
  def clean_extra(extra=nil)
    extra ||= self.extra
    extra.each do |k,v|
      if not v or v.blank? or k.blank?
        extra.delete(k)
        next
      end
      case v
      when (String)
        if Stats::Fields.include?(k) or v =~ /\d+/
          extra[k] = v.to_i
        else
          if v.instance_variable_defined?(:@_rails_html_safe)
            v.send(:remove_instance_variable, :@_rails_html_safe)
          end
          extra[k] = v
        end
      when Hash
        extra[k]=clean_extra(v)
      end
    end
    extra
  end
end
