# Collection of mixins for Backbone applications

## Backbone.Mixins.RouteFilter

add "before:route:whatever" or "after:route:whatever" filters to router of backbone

an example for using before filter to async a collection data:

```coffee
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
```

live demo: http://jsfiddle.net/cr2xvd6v/

---
