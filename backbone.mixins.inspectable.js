// Generated by CoffeeScript 1.7.1

/*
class Todo extends Backbone.Model
  _.extend @::, Backbone.Mixins.Inspectable

todo = new Todo
console.log todo.inspect()
 * => Object {className: "Todo", methods: Array[6], properties: Object}

console.log todo.methods()
 * => ["constructor", "inspect", "methods", "properties", "prototypeMethods", "prototypeProperties"]

console.log todo.properties()
 * => Object {cid="string", attributes="object", ...}
 */
Backbone.Mixins || (Backbone.Mixins = {});

Backbone.Mixins.Inspectable = (function() {
  var inspectClass;
  inspectClass = function(obj, options) {
    var className, classProto, err, methods, objClass, properties, t;
    if (options == null) {
      options = {};
    }
    objClass = void 0;
    className = void 0;
    classProto = void 0;
    methods = [];
    properties = {};
    t = void 0;
    try {
      if (typeof obj !== "function") {
        objClass = obj.constructor;
      } else {
        objClass = obj;
      }
      className = objClass.name;
      classProto = objClass.prototype;
      Object.getOwnPropertyNames(classProto).forEach(function(m) {
        t = typeof classProto[m];
        if (t === "function") {
          methods.push(m);
        } else {
          properties[m] = t;
        }
      });
      if (!options.prototype) {
        Object.getOwnPropertyNames(obj).forEach(function(m) {
          t = typeof obj[m];
          if (t === "function") {
            methods.push(m);
          } else {
            properties[m] = t;
          }
        });
      }
    } catch (_error) {
      err = _error;
      className = "undefined";
    }
    return {
      className: className,
      methods: methods,
      properties: properties
    };
  };
  return {
    inspect: function(options) {
      return inspectClass(this, options);
    },
    methods: function() {
      return inspectClass(this).methods;
    },
    properties: function() {
      return inspectClass(this).properties;
    },
    prototypeMethods: function() {
      return inspectClass(this, {
        prototype: true
      }).methods;
    },
    prototypeProperties: function() {
      return inspectClass(this, {
        prototype: true
      }).properties;
    }
  };
})();
