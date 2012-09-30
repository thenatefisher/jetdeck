class Jetdeck.Models.ActionModel extends Backbone.Model
    paramRoot: "todo"

    defaults:
      is_completed: null 
      title: null
      description: null
      due_at: null
      completed_at: null
      created_at: null 
      past_due: null
      list_due_at: null
      list_title: null
      due_today: false

class Jetdeck.Collections.ActionsCollection extends Backbone.CollectionBook

    model: Jetdeck.Models.ActionModel
    
    url: "/todos"
    
    initialize: ->
      @order = "due_at"
      @dx = "asc"
    
    orderBy : (o) ->
      @order = o

    direction : (d) ->
      @dx = d
      
    comparator: (i) ->
      d = 1
      d = -1 if @dx == "desc"
      
      if @order == "created_at"
          dt = new Date(i.get("created_at"))
          return d*dt
          
      if @order == "due_at"
          dt = new Date(i.get("due_at"))
          return d*dt    
          
      if @order == "completed_at"
          dt = new Date(i.get("completed_at"))
          return d*dt          
                

      return d * parseInt(i.get(@order), 10)    
