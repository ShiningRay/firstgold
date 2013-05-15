# -*- encoding : utf-8 -*-
class InsufficientMoney < StandardError
end
class RequirementsNotMet < StandardError
end
class Character < ActiveRecord::Base
  def notify *_args;  end
  belongs_to :user
  has_many :items, :foreign_key => 'owner_id'
  has_many :inventory,
             :class_name => 'Item',
             :foreign_key => 'owner_id',
             :conditions => 'in_slot is null'
  has_many :auctions, :foreign_key => 'seller_id'
  has_many :bids, :foreign_key => 'bidder_id'
  has_many :mails, :foreign_key => 'owner_id'
  has_and_belongs_to_many :badges
  belongs_to :scenario
  attr_accessible :name
  
  include IdentityMap
  include Stats


  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 16
  
  EquipmentSlots = [:head, :neck, :shoulder, :chest, :back, :main_hand, :off_hand, :hands, :waist, :wrist, :feet, :legs]
  Slots = EquipmentSlots + [:bank, :hidden]
  
  attr_accessor :equipments, :cooldowns
  attr_accessor :client
  serialize :abilities

  def calc_equipment item, plus=true
    return unless item.extra[:stats]
    
    item.extra[:stats].each do |k, v|
      if Stats::Fields.include?(k.to_sym)
        v = v.to_i
        @addition[k] ||= 0
        @addition[k] += plus ? v : -v
        clear_with_effect(k)
      end
    end
  end
  after_initialize :init
  def init
    puts "initialize"
    init_stats
    self.equipments={}
    self.points ||= 5
    @buffs = Set.new
    @debuffs = Set.new
    self.cooldowns = {}
    self.exp ||= 0
  
    items.each do |i|
      s = i.in_slot
      if EquipmentSlots.include? s
        self.equipments[s]=i
        calc_equipment(i)
      end
    end
  end

  
  # calc by character lvl
  def next_exp
    lvl * 100
  end


  # gain an item
  def gain_item(item)
    $logger.debug{"#{self} gain item: #{item}"}
    self.items << item
    notify "gain {\"item\":#{item.to_json}}"
  end

  def gain_items(*items)
    items.each {|i| gain_item i}
  end

  # gain some money
  def gain_money amount
    $logger.debug{"#{self} gain money: #{amount}"}
    self.money += amount
    save!
    notify("gain {\"money\":#{amount}}")
  end

  def inc_point k
    if points > 0 and Stats::BaseFields.include?(k)
      transaction do
        lock!
        self[k] += 1
        self.points -= 1
        save!
      end
      clear_with_effect(k)
    end
  end

  # gain some experiences
  def gain_exp amount
    $logger.debug{"#{self} gain exp: #{amount}"}
    self.exp += amount
    save!
    if exp >= next_exp
      transaction do
        lock!
        self.exp -= next_exp
        self.lvl += 1
        self.points += 5
        notify "levelup"
        save!
      end
    end
    notify "gain {\"exp\":#{amount}}"
  end

  #
  def as_json(opt={})
    Stats::Fields.each do |f|
      send f
    end
    v = attributes.dup
    v.symbolize_keys!
    v.merge!(final)
    v[:base] = base
    v[:next_exp] = next_exp
    v[:current_hp] = current_hp
    v[:current_mp] = current_mp
    v[:abilities] = @active_abilities.values.collect{|a|a.as_json}
    v
  end


  # get equipment from specific slot
  def get_slot(slot)
    equipments[slot]
  end

  # equip 
  def equip(item, slot=nil)
    raise GameError, 'no such item' unless item
    raise GameWarning, 'cannot equipe this item' unless item.equipable?
    slot ||= item.slot
    raise GameError unless EquipmentSlots.include?(slot)
    unequip(slot) if equipments[slot]
    if item.extra[:requirements]
      item.extra[:requirements].each do |key, value|
        raise RequirementsNotMet if send(key) < value
      end
    end
    self.equipments[slot] = item
    item.in_slot = slot.to_s
    item.save!
    calc_equipment(item)
    #notify "equip #{slot}&#{inventory_id}")
  end

  #unequip
  def unequip(slot)
    case slot
    when Item
      item = slot
      return unless item.slot == item.in_slot
    when Symbol
      item = equipments.delete(slot)
      return unless item
    end
    item.in_slot = nil
    item.save!

    calc_equipment(item, false)
#    connection.writeln("unequip #{slot}") if connection
  end
  
  # append an item to inventory
  def add_item(item)
    item = Item.find item unless item.is_a? Item
    $logger.debug{"#{self} add #{item}"}
    items << item
    inventory << item.id
    item
  end

  # remove an item from inventory at specific position
  # dispose an item from inventory at specific position
  def dispose_item(item)
    if self == item.owner
      equipments.delete(item.in_slot) if EquipmentSlots.include? item.in_slot
      item.destroy
      # TODO: notify
    end
  end

  def on_die
    @revive_timer = EM.add_timer(10){
      self.revive
    }
  end

  alias_method :sid, :id

  protected
end

