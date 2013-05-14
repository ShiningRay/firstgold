module Stats
  def self.included(base)
    Stats::Fields.each do |f|
    base.class_eval <<method
    def #{f}
      @final[:#{f}] ||= (@base[:#{f}].to_f + @addition[:#{f}].to_f)*(100+@percent[:#{f}].to_f)/100
    end
method
    end
    base.class_eval do
      alias_method :hr, :hit_rate
      alias_method :dr, :dodge_rate
      alias_method :cr, :critical_rate
      alias_method :ac, :armor
      attr_accessor :base, :addition, :percent, :final
    end
  end
  BaseFields=[:str, :agi, :spr,]
  Fields= BaseFields + [ :armor, :hp, :mp,
    :hit_rate, :dodge_rate, :critical_rate, :will, :resilience, :resistence,
    :attack_power
    ]
  FieldsCalc = {
    :attack_power => lambda{|c| c.str * c.lvl * 0.005},
    :resilience => lambda{|c| c.str * c.lvl * 0.005},
    :hit_rate => lambda{|c| c.agi * c.lvl * 0.0075},
    :dodge_rate => lambda{|c| c.agi * c.lvl * 0.005},
    :critical_rate => lambda{|c| c.agi * c.lvl * 0.002},
    :will => lambda{|c| c.spr * c.lvl * 0.005},
    :resistence => lambda{|c| c.spr * c.lvl * 0.003}
  }
  FieldsEffect = {
    :str => [ :attack_power, :resilience ],
    :agi => [:dodge_rate, :critical_rate, :hit_rate],
    :spr => [:will, :resistence]
  }
  def init_stats
    @base = {}
    @addition = {}
    @percent = {}
    @final = {}
    self.lvl ||= 1
    base[:hp] = self[:hp]
    base[:mp] = self[:mp]  
    Stats::BaseFields.each do |f|
      @base[f] = self[f]
      clear_with_effect(:str)
    end

    self.current_hp ||= self.hp
    self.current_mp ||= self.mp
    @active_abilities = {}
    self.abilities.each do |name|
      @active_abilities[name] = AbilityFactory.create(name, self)
    end if respond_to?(:abilities) and abilities
  end
  def clear_final(*keys)
    keys.each do |k|
      @final.delete(k)
    end
  end
  def clear_base(*keys)
    keys.each do |k|
      @base.delete(k)
    end
  end
  def clear_with_effect(k)
    e = Stats::FieldsEffect[k]||[]
    clear_final(k, *e)
    clear_base(*e)  
    e.each do |i|
      f = Stats::FieldsCalc[i]
      @base[i] = f.call(self)
    end
  end

#  protected :clear_final
  def str_b=(n)
    n = n.to_i
    self[:str] = n
    @base[:str] = n
    clear_with_effect(:str)    
  end

  def agi_b= n
    n = n.to_i
    self[:str] = n
    @base[:agi] = n
    clear_with_effect(:agi)
  end

  def spr_b= n
    n = n.to_i
    self[:spr] = n
    @base[:spr] = n
    clear_with_effect(:spr)
  end

  def armor
    0.5 * lvl
  end
end
