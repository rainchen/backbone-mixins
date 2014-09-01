# add "inspect", "methods" and "properties" methods to class, make it easy to inspect the structure of an instance object
# usage example:
###
class Todo extends Backbone.Model
  _.extend @::, Backbone.Mixins.Inspectable

todo = new Todo
console.log todo.inspect()
# => Object {className: "Todo", methods: Array[6], properties: Object}

console.log todo.methods()
# => ["constructor", "inspect", "methods", "properties", "prototypeMethods", "prototypeProperties"]

console.log todo.properties()
# => Object {cid="string", attributes="object", ...}
###
Backbone.Mixins ||= {}
(->
  Backbone.Mixins.Inspectable =
    inspect: (options) -> inspectClass(@, options)

    methods: -> inspectClass(@).methods
    properties: -> inspectClass(@).properties

    prototypeMethods: -> inspectClass(@, prototype: true).methods
    prototypeProperties: -> inspectClass(@, prototype: true).properties


  # This function receives an arbitrary object and returns the name of it's prototype, a list with all it's methods and an object with the name of it's properties (and their types).
  # options should one {prototype: true}
  # return a hash object like {className: "", methods: [...], attributes: {..}}
  # ref: http://stackoverflow.com/a/21738527/130353
  inspectClass = (obj, options = {}) ->
    objClass = undefined
    className = undefined
    classProto = undefined
    methods = []
    properties = {}
    t = undefined
    try
      unless typeof (obj) is "function"
        objClass = obj.constructor
      else
        objClass = obj
      className = objClass.name
      classProto = objClass::
      Object.getOwnPropertyNames(classProto).forEach (m) ->
        t = typeof (classProto[m])
        if t is "function"
          methods.push m
        else
          properties[m] = t
        return
      if !options.prototype
        Object.getOwnPropertyNames(obj).forEach (m) ->
          t = typeof (obj[m])
          if t is "function"
            methods.push m
          else
            properties[m] = t
          return
    catch err
      className = "undefined"
    # return result
    className: className
    methods: methods
    properties: properties
)()
