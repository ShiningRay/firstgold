# -*- encoding : utf-8 -*-
# learning prerequisite
# learning cost
# casting prerequisite
# casting cost
$abilities = {}

class GameWarning < Exception
end

class GameError < Exception
end

class AbilityFactory
  cattr_accessor :discovered
  @@discovered = {}

  # requires worklings so that they are added to routing.
  class << self
    def discover!
      Dir.glob(load_path.map { |p| "#{ p }/**/*.rb" }).each { |wling| require wling }
    end

    def [](name)
      discovered[name]
    end
    def add(subclass)
      discovered[subclass.name]=subclass unless subclass.abstract
    end
    def create(name, who)
      discovered[name].new(who) if discovered[name]
    end
  end
end

class Ability
  @abstract = true
  @passive = false
  class << self
    attr_accessor :title, :description, :abstract, :passive
    
    def inherited(subclass)
      AbilityFactory.add(subclass)
    end
  end
  attr_accessor :cooldown_duration, :me, :ready_time
  
  def initialize(m)
    self.me = m
    self.cooldown_duration = 5
  end

  def description
    self.class.description
  end
  
  def title
    self.class.title
  end

  def name
    self.class.name
  end

  # for subclass to override
  def prerequisites(target)
    raise GameWarning, "你已经死亡！" if me.dead?
    raise GameWarning, "Target is dead" if target.dead?
  end

  #abstract for subclass to override
  def consume
  end

  #abstract for subclass to override
  def do_effect(target)
  end
  
  def check_cooldown
    raise GameWarning, "#{name} is not ready" if recharging?
  end

  def recharge
    self.ready_time = Time.now + cooldown_duration
    me.notify("recharge #{name} #{cooldown_duration}")
  end

  def recharging?
    ready_time && ready_time > Time.now
  end
  
  def ready?
    !ready_time || ready_time < Time.now
  end

  def ready!
    if recharging?
      self.ready_time = nil
      me.notify("combat #{ {:type => :ready, :ability => name}.to_json }")
    end
  end

  def cast(target)
    $logger.debug("#{me} cast #{title} to #{target}")
    check_cooldown
    prerequisites(target)
    consume
    recharge
    do_effect(target, Effect.new(:with => self, :from => me, :to => target))
  end
  # misc method for roll range with critical
  def roll_amount(e, dmg1, dmg2, coefficient=2)
    if rand(20) == 0
      e.crit!
      e.amount = roll(dmg1*coefficient, dmg2*coefficient)
    else
      e.amount = roll(dmg1, dmg2)
    end
    e
  end

  def as_json
    {:id => name, :name => name, :title => title, :description => description}
  end
  def to_json
    as_json.to_json
  end
end

class Attack < Ability
  self.title = '攻击'
  self.description = '测试测试'
  
  def do_effect(target, effect)

    if me.is_a?(Character) and weapon = me.get_slot(:main_hand)
      dmg1 = weapon.extra['dmg1'].to_i
      dmg2 = weapon.extra['dmg2'].to_i
    else
      dmg1 = 4
      dmg2 = 6
    end
    effect.type = :melee
    if (d(20) + me.hr) > (5 + target.dr)
      effect = roll_amount(effect, dmg1, dmg2)
      target.damage(effect)
    else
      target.miss(effect) #miss
    end    
    effect
  end
end

class Spell < Ability
  @abstract = true
end

class Healing < Spell
  def do_effect(target, effect)
    effect.type = :heal
    effect = roll_amount(effect, 10, 20)
    target.heal(effect)
    effect
  end
end

class Firebolt < Spell
  self.title = '火球术'
  self.description = '测试测试'
  
  def do_effect(target, effect)
    effect.type = :fire
    effect = roll_amount(effect, 10, 20, 1.5)
    target.damage(effect)
    target.add_effect(
      DamageOverTime.new(
        :name => 'burning',
        :caster => me,
        :target => target,
        :interval => 2,
        :duration => 10,
        :effect => 
          Effect.new(:with => self,
            :from => me,
            :to => target,
            :type => :fire,
            :amount => 3)))
  end
end

# instant effect
class Effect
  attr_accessor :type, :amount, :from, :to, :with, :extra
  def initialize(options)
    self.type = options.delete(:type)
    self.with = options.delete(:with)
    self.from = options.delete(:from)
    self.to = options.delete(:to)
    self.amount = options.delete(:amount) || 0
    self.extra = options.delete(:extra) || []
  end

  def crit!
    extra << :crit
  end
  
  def to_json
    { :type => type,
      :amount => amount,
      :from => from.sid,
      :to => to.sid,
      :with => with.name,
      :extra => extra
    }.to_json
  end
end

# an effect that has no specific end time, e.g. aura
# must be removed by special means
class PersistentEffect
  class << self
    def activate_hooks
      @active_hooks ||= []
    end

    def deactivate_hooks
      @deactive_hooks ||= []
    end

    def on_activate &block
      activate_hooks << block
    end
    
    def on_deactivate &block
      deactivate_hooks << block
    end
  end

  attr_accessor :caster, :target
  attr_accessor :name, :positive

  attr_accessor :activate_hooks, :deactivate_hooks

  def positive?
    positive
  end

  def initialize(options)
    @activate_hooks = []
    @deactivate_hooks = []
    options.each do |k,v|
      accessor = "#{k}="
      send(accessor, v) if self.respond_to?(accessor)
    end
  end

  def on_activate &block
    activate_hooks << block
    self
  end

  def on_deactivate &block
    deactivate_hooks << block
    self
  end
  
  #hooks, when player get the effect, it can gain some benifit like growth in
  #str, etc
  def activate
    (self.class.activate_hooks + activate_hooks).each do |block|
      block.call self
    end
  end

  #hooks, when the effect is removed from the player, also remove the gain it
  #gave to the player
  def deactivate
    (self.class.deactivate_hooks + deactivate_hooks).each do |block|
      block.call self
    end
  end

  def to_s
    "#{name}:"
  end

  def to_json
#    puts options
    { :name => name,
      :caster => caster.id,
      :target => target.id,
      :positive => positive}.to_json
  end
end

# an effect that will last for a specific duration of time
module ContinuingEffect
  def self.included(klass)
    klass.class_eval do
      attr_accessor :duration
      on_activate do |effect|
        effect.instance_variable_set('@timer', EM.add_timer(effect.duration) do
          effect.target.remove_effect(effect)
        end)
      end
      on_deactivate do |effect|
        EM.cancel_timer effect.instance_variable_get('@timer')
      end
    end
  end
end

# an effect will do some other instant effect within every specific interval
# a behavior for
module EffectOverTime
  def self.included(klass)
    klass.class_eval do
      attr_accessor :effect, :interval
      on_activate do |effect|
        effect.instance_variable_set('@ptimer',
          EM.add_periodic_timer(effect.interval, effect.method(:do_effect)))
      end

      on_deactivate do |effect|
        effect.instance_variable_get('@ptimer').cancel
      end
    end
  end
end

class DamageOverTime < PersistentEffect
  include ContinuingEffect
  include EffectOverTime
  def initialize(options)
    self.positive = false
    super options
  end
  def do_effect
    target.damage(effect.dup)
  end
end

class HealOverTime < PersistentEffect
  include ContinuingEffect
  include EffectOverTime
  
  def do_effect
    target.heal(effect.dup)
  end
end
