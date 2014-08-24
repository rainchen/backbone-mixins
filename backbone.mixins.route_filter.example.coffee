class TodosCollection extends Backbone.Collection
  fetch: (options) -> options.success && _.delay((=> options.success()), 1000) # faking fetched and trigger the success callback
  get: (id) -> {} if id == "123" # faking found a todo if id 123

class TodosRouter extends Backbone.Router
  _.extend @::, Backbone.Mixins.RouteFilter # mixin RouteFilter

  routes:
    "": "index",
    "todo/:id": "show"

  initialize: (options) ->
    @todos = new TodosCollection()

    @on 'before:route:index', =>
      console.log 'fetch todos'
      @todos.fetch(reset: true) if !@todos.any()

    @on 'before:route:show before:route:edit', @findTodo

    @on 'after:route:show', (id)-> console.log "todo:#{id} is shown"

  findTodo: (id)->
    console.log "findTodo #{id}"
    if !@todos.get(id)
      @halt() # stop the original route callback and after filter from running
      if !@todos.any()
        @todos.fetch
          success: =>
            if @todos.get(id)
              @resume() # continue the original route callback and after filter from running
            else
              console.log "Not found #{id}"

  index: ->
    console.log "render index view"

  show: (id) ->
    console.log "render show view for #{id}"


# Instantiate the Router.
router = new TodosRouter()

# Start the history.
console.info "Navigate to index route"
Backbone.history.start()

console.info "Navigate to show an existing todo"
router.navigate "todo/123", true

console.info "Navigate to a not exists todo"
router.navigate "todo/234", true
