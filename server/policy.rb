require 'rubygems'
require 'eventmachine'

$policy = <<xml
<?xml version="1.0"?>
<!DOCTYPE cross-domain-policy SYSTEM "/xml/dtds/cross-domain-policy.dtd">

<!-- Policy file for xmlsocket://socks.example.com -->
<cross-domain-policy>

   <!-- This is a master socket policy file -->
   <!-- No other socket policies on the host will be permitted -->
   <site-control permitted-cross-domain-policies="master-only"/>

   <!-- Instead of setting to-ports="*", administrator's can use ranges and commas -->
   <!-- This will allow access to ports 123, 456, 457 and 458 -->
   <allow-access-from domain="*" to-ports="*" />

</cross-domain-policy>
xml
module PolicyServer
  def post_init
    @data = ""
    puts get_peername()
  end
  def receive_data data
    @data << data
    if @data == "<policy-file-request/>\0"
      send_data($policy)
      close_connection_after_writing
    end
  end
end

EM.epoll
EM.run {
  EM.start_server "0.0.0.0", 843, PolicyServer
}
