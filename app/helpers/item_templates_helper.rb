# -*- encoding : utf-8 -*-
module ItemTemplatesHelper
  def extra_text_field obj, fields
    
    n = obj.class.name.underscore
    unless fields.is_a?(Array)
      fields = fields.to_s.split(/\./)
    end
    fn = fields.collect{|i|"[#{i}]"}
    extra=obj.extra
    fields.each do |f|
      if extra[f]
        extra=extra[f]
      else
        extra = nil
        break
      end
    end
    "<input type='text' name='#{n}[extra]#{fn}' value='#{extra}' />"
  end
end
