# add "before:route:whatever" or "after:route:whatever" filters to router of backbone
# an example for using before filter to async a collection data:
###
class TodosRouter extends Backbone.Router
  _.extend @::, Backbone.Mixins.RouteFilter

  initialize: (options) ->
    @todos = new TodosCollection()

    @on 'before:route:index', =>
      @todos.fetch(reset: true) if !@todos.any()

    @on 'before:route:show before:route:edit', @findTodo

    @on 'after:route:show', -> console.info 'todo is shown'

  findTodo: (id)->
    if !@todos.get(id)
      @halt() # stop the original route callback and after filter from running
      if !@todos.any()
        @todos.fetch
          success: =>
            if @todos.get(id)
              @resume() # continue the original route callback and after filter from running
###
Backbone.Mixins ||= {}
Backbone.Mixins.RouteFilter =
  # overwrite the route method to trigger "before:route:#{action}"
  route: (route, name, callback) ->
    Backbone.Router::route.call @, route, name, ->
      @_halted = false # reset the flag
      @trigger.apply @, ["before:route:#{name}"].concat(_.toArray(arguments)) # trigger before filter callback
      # using @trigger.apply can not get the return result, so use a special attribute "_halted" to prevent the original route callback and after filter from running.
      if @_halted == true # log the halted info
        @_halted = {name: name, arguments: arguments}
      else
        callback = @[name] if !callback
        callback?.apply @, arguments # trigger original route callback
        @trigger.apply @, ["after:route:#{name}"].concat(_.toArray(arguments)) # trigger after filter callback
      @

  # call halt() method in a before filter will prevent the original route callback and after filter from running.
  halt: ()-> @_halted = true

  # once called halt(), it can be call resume() to continue the original route callback
  resume: ()->
    if @_halted && @_halted.name
      callback = @[@_halted.name]
      callback?.apply @, @_halted.arguments # trigger original route callback
    @_halted = false # reset the flag
