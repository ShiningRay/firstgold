JS.Forwardable=new JS.Module({defineDelegator:function(c,e,d){d=d||e;this.define(d,function(){var a=this[c],b=a[e];return JS.isFn(b)?b.apply(a,arguments):b})},defineDelegators:function(){var a=JS.array(arguments),b=a.shift(),c=a.length;while(c--)this.defineDelegator(b,a[c])}});