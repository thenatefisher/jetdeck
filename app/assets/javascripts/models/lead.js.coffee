class Jetdeck.Models.Lead extends Backbone.Model
  paramRoot: 'lead'

  defaults:
    email: ""
    fire: false
    hits: 0
    first: ""
    last: ""
    last_viewed: ""
    recipient_id: 0
    url: "/"

class Jetdeck.Collections.LeadsCollection extends Backbone.CollectionBook
  model: Jetdeck.Models.Lead
  url: '/leads'

  initialize : () =>
    @on('change', @updateAirframe, this)
    @on('add', @updateAirframe, this)
    @on('remove', @updateAirframe, this)
    @order = "last_viewed"
    @dx = "desc"      

  updateAirframe : () =>
    if @airframe
        @airframe.set('leads', @toJSON())  

  orderBy : (o) ->
    @order = o

  direction : (d) ->
    @dx = d
    
  comparator: (i) ->
    d = 1
    d = -1 if @dx == "desc"
    
    if @order == "created_at" 
        if i.get("created_at") 
            dt = new Date(i.get("created_at"))
            return d*dt
        else   
            return -1

    if @order == "last_viewed"
        if i.get("last_viewed") 
            dt = new Date(i.get("last_viewed"))
            return d*dt 
        else
            return -1      

    if !isNaN (parseInt(i.get(@order), 10))
        return d * parseInt(i.get(@order), 10)
    
    if i.get(@order)
        if d == 1
            return i.get(@order)
        else
            return String.fromCharCode.apply(String,
                _.map(i.get(@order).split(""), (c) ->
                    return 0xffff - c.charCodeAt()
                )
            )
