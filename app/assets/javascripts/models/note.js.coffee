class Jetdeck.Models.NoteModel extends Backbone.Model
    paramRoot: "note"

    defaults:
      type: null 
      title: null
      description: null
      created_at: null
      author: null 
      is_mine: false

class Jetdeck.Collections.NotesCollection extends Backbone.CollectionBook

    model: Jetdeck.Models.NoteModel
    
    url: "/notes"
    
    initialize: ->
      @order = "created_at"
      @dx = "desc"
    
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
                   
      return d * parseInt(i.get(@order), 10)    
