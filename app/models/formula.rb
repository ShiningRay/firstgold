class InsufficientItem < StandardError
end
class Formula < ActiveRecord::Base
  serialize :input
  serialize :output

  def after_initialize
    self.input ||= {}
    self.output ||= {}
  end

  def check(character)
    
  end
  def apply(character)
    inputs = character.inventory.find :all, :conditions => {:template_id => input.keys}

    rec = input.dup
    
    rec.each do |k,v|
      rec[k] = []
    end
    
    for i in inputs
      rec[i.template_id] << i
    end

    rec.each do |k,v|
      if v.size < input[k]
        raise 
      end
    end
    #transaction do
      input.each do |template_id, quantity|
        rec[template_id][0,quantity].each do |r|
          r.destroy
        end
      end
      
      for k,v in output
        t = ItemTemplate.find k
        i = t.generate
        #i.quantity = v.to_i
        character.items << i
      end
    #end
  end
  ##  1 => 1, 2 => 2
end
