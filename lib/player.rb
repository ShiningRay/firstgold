module Player
  def self.included(base)
    base.class_eval do
      attr_accessor :client
      #attr_accessor :buffs, :debuffs
      def notify(*args)
        client.writeln(args.join("\n")) if client
      end      
    end
  end
  
  def scenario
    @scenario ||= Scenario[scenario_id]
  end

  def scenario=(new_scenario)
    @scenario = new_scenario
    self.scenario_id = new_scenario.id
  end
  
  def receive(effect)
    case effect[:type]
    when :heal
    when :buff
    when :debuff
    end
  end
  
  def buffs
    @buffs ||= []
  end

  def buffs=(buffs)
    @buffs = (buffs)
  end

  def debuffs
    @debuffs ||= []
  end

  def debuffs=(debuffs)
    @debuffs = debuffs
  end

  def add_effect(buff)
    return unless alive?
    (buff.positive? ? buffs : debuffs) << buff
    buff.activate
    scenario << [:add_effect, buff.to_json]
  end

  def remove_effect(buff)
    (buff.positive? ? buffs : debuffs).delete(buff).deactivate
    scenario << [:remove_effect, buff.to_json]
  end

  def remove_all_effects
    (debuffs + buffs).each do |e|
      e.deactivate
      scenario << [:remove_effect, e.to_json]
    end
  end
  
  def heal(amount)
    scenario << [:combat, effect]
    self.current_hp = [self.current_hp + amount, self.hp].min
  end

  def miss(effect)
    effect.amount = -1
    scenario << [:combat, effect]
  end

  def damage(effect)
    effect.amount =  [effect.amount - ac, 0].max
    h = current_hp - effect.amount
    scenario << [:combat, effect]
    
    if h <= 0
      self.current_hp = 0
      scenario << [:die, sid]
      remove_all_effects
      on_die
    else
      self.current_hp = h
      under_attack(effect)
    end
  end

  def cast(ability_name, target=nil)
    a = @active_abilities[ability_name]
    raise GameError, ("you dont know about #{ability_name}") unless a
    a.cast(target)
  end

  def start_auto_cast(ability_name, target=nil)
    if target
      @target = target
    else
      target = @target
    end
    raise GameError, ("you dont know about #{ability_name}") unless ability = @active_abilities[ability_name]
    unless @auto_caster
      @auto_caster = EM.add_periodic_timer(ability.cooldown_duration){
        begin
          ability.cast(target)
        rescue GameWarning
        ensure
          stop_auto_cast if target.dead?
        end
      }
    end
  end
  
  def revive
    self.current_hp = hp
    scenario.broadcast([:revive, sid])
  end
  
  def stop_auto_cast
    if @auto_caster
      @auto_caster.cancel
      @auto_caster = nil
    end
  end

  def dead?
    current_hp == 0
  end

  def alive?
    current_hp > 0
  end

  #########################callbacks#########################

  def on_die

  end

  def under_attack(effect)
    
  end

  def to_s
    "#{name}\##{id}(#{current_hp}/#{hp})"
  end
  
  def inspect
    to_s
  end
end
