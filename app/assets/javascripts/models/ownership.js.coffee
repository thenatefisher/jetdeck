class Jetdeck.Models.OwnershipModel extends Backbone.Model
    paramRoot: "ownership"

    defaults:
      assoc: null
      description: null
      created_at: null
      assigned: false

class Jetdeck.Collections.OwnershipCollection extends Backbone.CollectionBook

    model: Jetdeck.Models.OwnershipModel
    
    url: "/ownerships"
    
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
