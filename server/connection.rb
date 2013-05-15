# -*- encoding : utf-8 -*-
require 'rubygems'
#require 'ruby-debug'
require 'eventmachine'
require 'model'
require 'json'
require 'ap'
# for online characters

module FirstGold
  module Server
    module Commands
      def login(session_id, character_id)
        return error('you have already logged in', true) if @character
          
        puts "login #{session_id}, #{character_id}"
        @character = Character[character_id]
        return error('No such character', true) unless @character
#          @character.scenario = $scenario
        scenario.players.each do |id, ch|
          send_data("data #{ch.to_json}\r\n")
        end
        @sid = scenario.channel.subscribe do |msg|
          puts "sending"
          puts msg.inspect
          if msg[0] == :combat
            writeln("combat #{msg[1].to_json}")
          else
            writeln(msg.join(' '))
          end
        end

        @character.client = self
        character = @character
        scenario.join(character)        
        @saver = EM.add_periodic_timer 5*60 do
          character.save
          puts "#{character.id} saved!"
        end
      end

#      def target(target_id)
#        target = $scenario.players[target_id]
#        if @target
#          @target = target
#        else
#          error('no such target')
#        end
#      end

      def cast(ability, target_id)
        target_id = target_id.to_i
        return error('No such target') unless target = scenario.players[target_id]
        #return error('you do not know that ability') unless ability
        @character.cast(ability, target)
      end

      def say(msg)
        scenario << [:say, @character.id, msg]
      end

      def quit
        #TODO set the character status to quiting, save back the status to the database and then remove it from cache
        #check if the character is okay to quit(not in combat)
        self.status = 'quit'
        
        close_connection_after_writing
      end
    end
  end
end

module FirstGold
  module Server
    class Connection < EventMachine::Connection
      include EventMachine::Protocols::LineText2
      include Commands
      attr_accessor :character, :session_id, :status, :scenario

      def post_init
        @status = :login
      end
      
      def receive_line ln
        ln.strip!
        return if ln.size == 0
        puts ln
        command, parameters = ln.split(/ /, 2)
        parameters = parameters ? parameters.split(/&/) : []
        send(command, *parameters)
      rescue GameWarning => w
        warning(w.message)
#        print w.backtrace.join("\n")
      rescue GameError => e
        error(e.message)
#        print e.backtrace.join("\n")
      rescue NoMethodError => e
        error("unknown command")
        p e
        print e.backtrace.join("\n")
      rescue Exception => e
        error('fatal error!')
        p e
        print e.backtrace.join("\n")
      end

      def unbind
        # TODO: remove character from online table after a period of time
        # unless client explicitly send "quit" command
        # if the client explicity send "quit" command and it's ok for it to quit
        # then immediately remove character from cache
        $logger.debug{ "#{@character} unbind!"}
        if @character
          @character.save
          $logger.debug{ "#{character.name} quited"}
          scenario.quit(@character)
          @saver.cancel
          @character = nil
        end
        scenario.channel.unsubscribe(@sid) if @sid
        @sid = nil
      end

      def writeln(content)
#        p content
#        $logger.debug(@character.name){content}
        send_data("#{content}\r\n")
      end

      def error(content, quit=false)
        send_data("error #{content}\r\n")
        close_connection_after_writing if quit
      end
      
      def warning(content)
        send_data("warning #{content}\r\n")
      end
    end
  end
end


require 'irb'
 
module IRB # :nodoc:
  def self.start_session(binding)
    unless @__initialized
      args = ARGV
      ARGV.replace(ARGV.dup)
      IRB.setup(nil)
      ARGV.replace(args)
      @__initialized = true
    end
 
    workspace = WorkSpace.new(binding)
 
    irb = Irb.new(workspace)
 
    @CONF[:IRB_RC].call(irb.context) if @CONF[:IRB_RC]
    @CONF[:MAIN_CONTEXT] = irb.context
 
    catch(:IRB_EXIT) do
      irb.eval_input
    end
    EM.stop
  end
end

irb_t = Thread.new {
  IRB.start_session(binding)
}

EM.epoll
Character.class_eval do
  include Player
end
Npc.class_eval do
  include Player
end
EM.run { 
  EM.start_server('0.0.0.0', 8000, FirstGold::Server::Connection) {|conn|
    conn.scenario = Scenario[0].init_server
  }
}
irb_t.join
