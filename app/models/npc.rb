# -*- encoding : utf-8 -*-
class Npc < ActiveRecord::Base
  has_many :drops
  belongs_to :scenario
  serialize :abilities
  include Stats
#  include Player

  # TODO: generate a list of items that npc will drop
  # copy from item_template
  def drop
    drops.collect { |d| d.roll }.compact
  end
  
#  attr_accessor :scenario, :type
  attr_accessor :current_hp, :current_mp

  def initialize(*args)
    @base = {}
    @addition = {}
    @percent = {}
    @final = {}
    super *args
  end

  def after_initialize()
    init_stats
  end

  def money
    rand(lvl * 10)
  end

  def as_json(*args)
    v = attributes.dup
    v.symbolize_keys!
    v.merge!(final)
    v[:base] = base
    v[:current_hp] = current_hp
    v[:current_mp] = current_mp
    v[:type] = 'npc'
    v[:id] = -id
    v
  end

  ############### game behaviour ################
  def under_attack(effect)
    $logger.debug{"#{self} is under attack"}
    EM.next_tick{
      start_auto_cast('Attack', effect.from)
    } if alive?
  end
  
  def on_die
    $logger.debug{"#{self} died"}
    remove_all_effects
    stop_auto_cast
    return unless @target
    
    @target.gain_exp lvl*10
    @target.gain_money money
    @target.gain_items drop
    
    EM.add_timer(5){
      scenario.quit(self)

      EM.add_timer(60){
        self.current_hp = self.hp
        scenario.join(self)
      }
    }
  end
  def sid
    -id
  end
  private

end

NPC = Npc
