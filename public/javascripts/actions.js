if (!String._FORMAT_SEPARATOR){
    String._FORMAT_SEPARATOR = String.fromCharCode(0x1f);
    String._FORMAT_ARGS_PATTERN = new RegExp('^[^' + String._FORMAT_SEPARATOR + ']*'
        + new Array(100).join('(?:.([^' + String._FORMAT_SEPARATOR + ']*))?'));
}
if (!String.format)
String.format = function (s){
    return Array.prototype.join.call(arguments, String._FORMAT_SEPARATOR).
        replace(String._FORMAT_ARGS_PATTERN, s);
}
if (!''.format)
String.prototype.format = function (){
    return (String._FORMAT_SEPARATOR +
        Array.prototype.join.call(arguments, String._FORMAT_SEPARATOR)).
        replace(String._FORMAT_ARGS_PATTERN, this);
}

var Session = {};

var Model=new JS.Class({
	include: JS.Observable,
    extend: {
        records : {},
        get : function(id){
            return this.records[id];
        },
        set : function(id, obj){
            this.records[id] = obj;
        },
        remove: function(id){
            var c = this.get(id);
            c.notifyObservers({type: 'destroy'});
            delete this.records[id];
		}
    },
	initialize: function(data){
		this._data = data || {};
        if(data['id']){
            this.klass.set(data['id'], this);
        }
	},
	set: function(key, val){
		if(this._data[key] != val){
			this._data[key] = val;
			this.notifyObservers({type: 'update', key: key, value: val});
		}
	},
	get: function(key){
		return this._data[key];
	},
    increment: function(key, d){
               this._data[key]+=d;
                this.notifyObservers({type: 'update', key: key, value: val});
             },
	data: function(newData){
		if(newData){
			this._data = newData;
			this.notifyObservers();
			return this;
		} else {
			return this._data;
		}
	},
	destroy: function(){
		this.notifyObservers({type: 'destroy'});
		delete this._data;
		delete this;
	}
});
var View=new JS.Class({
	initialize: function(model){
		this.bind(model);
	},
	bind: function(model){
		this._model = model;
		model.subscribe(this.handleEvent, this);
	},
	handleEvent: function(event){
		if(typeof event != 'undefined'){
			if(typeof event.type != 'undefined'){
				var methodName = 'on' + event.type;
				if(typeof this[methodName] == 'function'){
					this[methodName].call(this, event);
				}
			}
		}
	},
	onupdate: function(event){
		var methodName;
		if(typeof event.key != 'undefined'){
			methodName = 'onupdate_' + event.key;
			if(typeof this[methodName] == 'function'){
				this[methodName].call(this, event.value);
			}
		}else{
			$.each(this._data, function(k,v){
				methodName = 'onupdate_' + k;
				if(typeof this[methodName] == 'function'){
					this[methodName].call(this, v);
				}
			});
		}
	},
	ondestroy: function(){
		if(typeof this['destroy'] == 'function'){
			this.destroy();
		}
	},
    destroy: function(){
        return this._model.unsubscribe(this.handleEvent, this);
    }
})


var Ability = new JS.Class(Model, {
    recharge: function(sec){
        this._ready = false;
        this._coolingTimer = setTimeout(function(obj){obj.ready();}, sec*1000, this);
        this._castTimestamp = new Date();
        this.notifyObservers({type: 'recharge', time: sec});
    },
    ready: function(){
        clearTimeout(this._coolingTimer);
        this._castTimestamp = false;
        if(!this._ready){
            this._ready = true;
            this.notifyObservers({type: 'ready'});
            if(this._auto && Session.target){this.cast();}
        }
    },
	isReady: function(){
		return !!this._ready;
	},
    cast: function(){
        send(['cast', this.get('name') + '&' + Session.target.get('id')]);
    },
    startAutoCast: function(){
        if(!this._auto){
            this._auto=true;
            if(this.isReady()){
                this.cast();
            }
        }
    },
    stopAutoCast: function(){
        if(this._auto){
            this._auto = false;
        }
    }
});

var AbilityView = new JS.Class(View, {
	initialize: function(model){
        this._template = new EJS({url:'/ejs/ability.ejs?2'});
		this._element = $(this._template.render(model.data())).appendTo('#abilities');
        this._progressbar = $('#progressbar-'+model.get('name'));
        this.callSuper(model);
        var self = this;
        this._button = $('#'+model.get('name')).click(function(){
            self._model.cast();
        });
        this._auto_cast = $('#auto-'+model.get('name')).change(function(){
            if(self._auto_cast.attr('checked')){
                self._auto_cast.attr('checked', 'checked');
                self._model.startAutoCast();
            }else{
                self._auto_cast.removeAttr('checked');
                self._model.stopAutoCast();
            }
        });
	},
    onrecharge: function(event){
        this._element.attr('disabled', 'disabled');
        this._progressbar.width(this._element.width()).animate({width:0}, event.time*1000, 'linear');

    },
    onready: function(){
        this._element.removeAttr('disabled');
        this._progressbar.width(0);
    }
})

var CharacterView = new JS.Class(View, {
	initialize: function(model){
        this._template = new EJS({url:'/ejs/character.ejs?3'});
        if(model == Session.self){
            this._element = $(this._template.render(model.data())).insertBefore('#character-list');
        }else{
            this._element = $(this._template.render(model.data())).appendTo('#character-list');
        }
        var hpinfo = this._hpinfo = this._element.find('div.hpinfo');
        this._hpbar = new BoundedBar(model, 'current_hp', 'hp',
          this._element.find('.boundedbar').mouseenter(function(e){
             hpinfo.scrollTop(e.pageY).scrollLeft(e.pageX).show();
          }).mouseleave(function(){
             hpinfo.hide();
          }));
		this._hp = this._element.find('span.hp');
		this._hpmax = this._element.find('span.hpmax');
		this._name = this._element.find('span.name');
		this._buff = this._element.find('.buff');
		this._combatinfo = this._element.find('.combatinfo');
		var self = this;
		this._element.click(this.method('onclick'));
		this.callSuper(model);
		if(this._model.get('id')==Session.character_id){
			this._element.addClass('self');
		}
	},
    onclick: function(){
		if(Session.targetView){
			Session.targetView.toggleTarget();
            Session.targetView=null
		}
		Session.target = this._model;
		Session.targetView = this;
		this.toggleTarget();
    },
	ondamage: function(event){
		var effect = event.effect, amount = effect.amount, self = this;
        this._combatinfo.scrollLeft(this._element.scrollLeft()).scrollTop(this._element.scrollTop());
		var display = function(){
			if(typeof effect.extra == 'object' && effect.extra.indexOf('crit') >= 0){
				self._combatinfo.text('-'+amount).show('puff', {percent: 200}, 618);
			}else{
				self._combatinfo.text('-'+amount).show();
			}
			self.timer = setTimeout(function(){
				self._combatinfo.fadeOut();
				self.timer = null;
			}, 1500);
		}
		if(this.timer){
			this._combatinfo.hide('fast', display);
			clearTimeout(this.timer);
			this.timer = null;
		}else{
			display();
		}
	},
	onupdate_buff: function(value){
		this._buff.text(value.join(' '));
	},
	onupdate_current_hp: function(value){
		if(value<=0){
            value=0;
			this._element.addClass('dead');
		}else{
			this._element.removeClass('dead');
		}
		this._hp.text(value);
	},
	onupdate_name: function(value){
		this._name.text(value);
	},
	onupdate_hp: function(hp){
		this._hpmax.text(hp);
	},
	toggleTarget: function(){
		this._element.toggleClass('target')
	},
	destroy: function(){
        if(Session.targetView == this){
            Session.targetView = null;
        }
        this.callSuper();
		this._element.remove();
		delete this._element;
		delete this._hp;
		delete this._hpmax;
		delete this._name;        
	}
});

var Character = new JS.Class(Model, {
//    initialize: function(data){
//        this.callSuper(data);
//        this._data.buff = [];
//    },
	addBuff: function(name){
		this._data.buff = this._data.buff  || [];
		this._data.buff.push(name);
		this.notifyObservers({type: 'update', key: 'buff', value: this._data.buff});
	},
	removeBuff: function(name){
        if(this._data.buff){
            this._data.buff.splice(this._data.buff.indexOf(name), 1);
            this.notifyObservers({type: 'update', key: 'buff', value: this._data.buff});
        }
	},
	isDead: function(){
		return this._data.current_hp <= 0;
	},
	isAlive: function(){
		return this._data.current_hp > 0;
	},
	damage: function(effect){
		this.set('current_hp', this.get('current_hp')-effect.amount);
		this.notifyObservers({type: 'damage', effect: effect});
	}
});
var Item = new JS.Class(Model, {
    
});
var Inventory = new JS.Class(Model, {
    initialize: function(ary){
        $.each(ary, function(i){
           
        });
    }
});

var ChatBox = {
	entries: 0,
    add: function(s,cls){
		if(++this.entries > 100){
			$('#chat').children().slice(0,50).remove();
			this.entries = 50;
		}
		$("<li/>").text(s).addClass(cls||'').appendTo('#chat');
		this.scrollBottom();
    },
	scrollBottom: function(){
		$('#chat').attr('scrollTop', ($('#chat').attr('scrollHeight') - $('#chat').attr('clientHeight')))
	}
}
var ContentView = new JS.Class(View, {
  initialize: function(model, key, el){
    this.callSuper(model);
    this.key = key;
    this._element = el;
    this.onupdate({key:key, value:model.get(key)});
  },
  onupdate: function(e){
    if(e.key == this.key){
      this._element.text(e.value);
    }
  }
});
var BoundedBar = new JS.Class(View, {
    initialize: function(model, current_key, max_key, el){
        this.callSuper(model);
        this.current_key = current_key;
        this.max_key = max_key;
        this._element = el;
        this._bar = el.children().eq(0);
        this.current_value = this._model.get(current_key);
        this.max_value = this._model.get(max_key);
        this.redraw();
    },
    redraw: function(){
        this._bar.width((this.current_value / this.max_value * 100) + '%');
    },
    onupdate: function(event){
        var r=false;
        if(event.key == this.current_key){
            this.current_value = event.value;
            r=true;
        }else if(event.key == this.max_key){
            this.max_value = event.value;
            r=true;
        }
        if(r){
            this.redraw();
        }
    }
});

var Action = {
join: function(who){
    ChatBox.add(who + ' joined');
},
quit: function(id){
    var c = Character.get(id);
    ChatBox.add(c.get('name') + ' quited');
	Character.remove(id);
},
data: function(){
    var d= $.evalJSON(Array.prototype.join.call(arguments, ' '));
	var ch = Character.get('id');
    if(typeof ch == 'undefined'){
        ch = new Character(d);
        if(ch.get('id') == Session.character_id){
            Session.self = ch;
            new BoundedBar(ch, 'exp', 'next_exp', $('#expbar'));
            new BoundedBar(ch, 'current_hp', 'hp',$( '#hpbar'));
            new ContentView(ch, 'money', $('#money'));
            new ContentView(ch, 'str', $('.stats .str'))
            new ContentView(ch, 'agi', $('.stats .agi'))
            new ContentView(ch, 'spr', $('.stats .spr'))
            new ContentView(ch, 'hit_rate', $('.stats .hit_rate'))
            new ContentView(ch, 'dodge_rate', $('.stats .dodge_rate'))
            new ContentView(ch, 'dmg1', $('.stats .dmg1'))
            new ContentView(ch, 'dmg2', $('.stats .dmg2'))
            new ContentView(ch, 'hp', $('.stats .hp'))
            new ContentView(ch, 'mp', $('.stats .mp'))
            new ContentView(ch, 'current_hp', $('.stats .current_hp'))
            new ContentView(ch, 'current_mp', $('.stats .current_mp'))
            new ContentView(ch, 'lvl', $('.stats .lvl'))
            new ContentView(ch, 'exp', $('.stats .exp'))
            new ContentView(ch, 'next_exp', $('.stats .next_exp'))
            new ContentView(ch, 'points', $('.stats .points'))
            $.each(ch.get('abilities'), function(i,a){
                new AbilityView(new Ability(a));
                });
        }
    }else{
        ch.data(d);
    }

	if($('#character-'+ch.get('id')).size()==0){
        new CharacterView(ch);
	}
},
combat: function(){
    var msg = Array.prototype.join.apply(arguments);
    msg = $.evalJSON(msg);
    var target = Character.get(msg['to']),
        me = Character.get(msg['from']);
    
    switch(msg['type']){
        case 'melee':
            if(msg.amount < 0){
                ChatBox.add('$1对$2释放的$3未命中'.format(me.get('name'), target.get('name'), msg['with']));
            }else{
                target.damage(msg);
                ChatBox.add('$1的$2对$3造成了$4点伤害'.format(me.get('name'), msg['with'] +( msg['extra'].indexOf('crit') >= 0 ? '暴击' : ''), target.get('name'), msg['amount']));
            }
            
            break;
        case 'heal':
            
        break;
        default:
            ChatBox.add('$1的$2对$3造成了$4点伤害'.format(me.get('name'), msg['with'] +( msg['extra'].indexOf('crit') >= 0 ? '暴击' : ''), target.get('name'), msg['amount']));
    }
},
recharge: function(ability, time){
    Ability.get(ability).recharge(time);
},
ready: function(ability){
    Ability.get(ability).ready();
},
add_effect: function(args){
    var effect = $.evalJSON(args);
    var target = Character.get(effect['target']);
    if(target) target.addBuff(effect['name']);
},
remove_effect: function(args){
    var effect = $.evalJSON(args);
    var target = Character.get(effect['target']);
    if(target) target.removeBuff(effect['name']);
},
//attack: function(from, to){
//	ChatBox.add(from + ' attacked ' + to);
//},
say: function(who, content){
	var who = Array.prototype.shift.apply(arguments);
	ChatBox.add(Character.get(who).get('name') +":"+content, 'say')
},
die: function(id){
	var c = Character.get(id);
	c.set('current_hp', 0);
	ChatBox.add(c.get('name') + "死亡了");
//	if(id == Session.self){
//		$('.skill').attr('disabled', 'disabled');
//	}
},
revive: function(who){
    var c = Character.get(who);
    c.set('current_hp', c.get('hp'));
    ChatBox.add((who == Session.self.get('name') ? '你' : c.get('name')) + "复活了");
},
gain: function(s){
  s = $.evalJSON(s);
  $.each(s, function(k,v){
      switch(k){
          case 'exp':
              Session.self.set('exp', Session.self.get('exp')+v);
              ChatBox.add("你获得了$1点经验值".format(v));
              break;
          case 'money':
              Session.self.set('money', Session.self.get('money')+v);
              ChatBox.add("你获得了$1 铜".format(v));
              break;
          case 'item':
              $.each(v, function(){
                ChatBox.add('你获得了物品“$1”'.format(this.name))
              });
      }
  })
},
levelup: function(){
	Session.self.set('exp', 0);
	alert('level up!');
},
//damage: function(from, to, what, amount){
//    var c = Character.get(to);
//    c.set('hp', c.get('hp') - parseInt(amount));
//    ChatBox.add(from + "'s " + what + " towards " + to + ' caused ' + amount + ' damages.');
//},
//heal: function(from, to, what, amount){
//	var c=Character.get(to);
//	var hp = c.get('hp') + parseInt(amount);
//	if(hp > c.get('hpmax')){
//		c.set('hp', c.get('hpmax'))
//	}else{
//		c.set('hp', hp)
//	}
//	ChatBox.add(to + " gained " + amount + " HP from " + from + "'s " + what)
//},
//buff: function(who, from, what){
//	ChatBox.add(who + " is affected by " + from + "'s " + what);
//	Character.get(who).addBuff(what);
//},
//removebuff: function(who, what){
//	ChatBox.add(what + " removed from " + who);
//	Character.get(who).removeBuff(what);
//},
//miss: function(what){
//          ChatBox.add(Session.self + "'s " + what+" missed");
//      },
error: function(){
    $('#error').text(Array.prototype.join.call(arguments, ' '));
    setTimeout(function(){$('#error').text('')}, 3000);
},
warning: function(){
    $('#error').text(Array.prototype.join.call(arguments, ' '));
    setTimeout(function(){$('#error').text('')}, 3000);
},
equip: function(slot, inventory_id){
    
},
unequip: function(slot){

},
add_item: function(item){
          },
update: function(args){
          var d = $.evalJSON(args);
          $.each(d, function(k,v){
              Session.self.set(k,v)
          })
        },
disposed: function(inventory_id){
    //Inventory.remove(inventory_id)
}
};
