/*
 * wrap low-level flash socket bridge apis
 * provide observe patterns
 */
swfobject.embedSWF("/javascripts/SocketBridge.swf", "socket", "0", "0", "9.0.0", "expressInstall.swf", {}, {
    menu: "false",
    scale: "noScale",
    bgcolor: "#FFFFFF",
    allowScriptAccess: 'all'
});
var Socket=(function(){
    var socket;
    
    function init_socket(){
        socket = document.getElementById('socket');
        try {
            socket.setCallback('data', '__ondata');
            socket.setCallback('connected', '__onconnected');
            socket.setCallback('closed', '__onclosed');
            socket.setCallback('ioerror', '__onioerror');
            socket.setCallback('securityerror', '__onsecurityerror');
            Socket.ready();
        } catch(e){
            //console.debug(e);
            setTimeout(init_socket, 1000);
        }            
    }
    init_socket();
    var empty = function(){}    
    return {
        ready: empty,
        data: empty,
        connected: empty,
        closed: empty,
        ioerror: empty,
        securityerror: empty,
        connect: function(a,b){return socket.connect(a,b)},
        send: function(d){return socket.send(d)},
        flush: function(){return socket.flush()},
        isConnected: function(){return socket.isConnected()}
    }
})();

function __onconnected(){
    Socket.connected();
}
function __ondata(d){
    Socket.data(d);
}
function __onclosed(){
    Socket.closed();
}
function __onioerror(){
    console.info('ioerror')
    Socket.ioerror();
}
function __onsecurityerror(){
    console.info('securityerror')
    Socket.securityerror();
}
