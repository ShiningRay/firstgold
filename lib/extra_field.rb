# -*- encoding : utf-8 -*-
module ExtraField
  def self.included(base)
    base.serialize :extra
    base.before_save :clean_extra
  end
  
  def after_initialize
    self.extra ||= {}
  end

  protected
  def clean_extra(extra=nil)
    extra ||= self.extra
    extra.each do |k,v|
      if not v or v.blank? or k.blank?
        extra.delete(k)
        next
      end
      case v
      when String
        if Stats::Fields.include?(k) or v =~ /\d+/
          extra[k] = v.to_i
        else
          if v.instance_variable_defined?(:@_rails_html_safe)
            v.send(:remove_instance_variable, :@_rails_html_safe)
          end
          extra[k] = v
        end
      when Hash
        if v.empty?
          extra.delete(k)
        else
          extra[k]=clean_extra(v)
        end
      end
    end
    extra
  end
end
