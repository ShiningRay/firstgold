class Scenario < ActiveRecord::Base
  include IdentityMap
  has_many :npcs
  has_many :characters
  belongs_to :owner, :class_name => 'Character'
  attr_accessor :channel, :players
  has_many :auctions, :as => :item
  
  has_attached_file :background,
                    :styles => { :medium => "300x300>",
                                 :thumb => "16x16#"},
                    :default_url =>"/images/scenario/2.gif"
                                 
  def after_initialize
  end

  def self.id_from_coordinate(x,y)
    (y << 4) | x
  end

  def x
    return nil unless id
    @x ||= (id & 0xf)
  end

  def y
    return nil unless id
    @y ||= ((id & 0xf0) >> 4)
  end

  def x=( x)
    @x= x.to_i
    self.id = id ? (((id ^ (id & 0xf))) | @x) : @x
  end

  def y=( y)
    @y= y.to_i
    self.id = id ? ((id ^ (id & 0xf0)) | (@y << 4)) : @y << 4
  end

  def to_param
    "#{x}-#{y}"
  end
  
  def self.find_by_coordinate x, y
    i = (y.to_i << 4) + x.to_i
    a = self[i]
    unless a
      a = new
      a.id = i
    end
    a
  end
  
  def init_server
    return self if @__initialized
    @__initialized = true
    self.channel = EM::Channel.new
    self.players = {}
    spawn_npc
    self
  end
  
  def broadcast(msg)
    puts "receive" 
    puts msg.inspect
    channel << msg if channel
  end
  
  alias << broadcast
  def spawn_npc
    npcs.each do |n|
#      u.count.times do
        join n
#      end
    end
  end

  def join(who)
    $logger.debug{who.inspect}
    who.scenario = self
    if who.is_a? Npc
      self.players[-who.id] = who
    else
      self.players[who.id] = who
      broadcast [:join, who.name]
    end
    broadcast [:data, who.to_json]
  end

  def quit(who)
    id = who.sid
    who = self.players.delete(id)
    $logger.debug{"#{id} #{who} quit"}
    broadcast [:quit, id]
  end
  

end
