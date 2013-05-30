class Jetdeck.Models.Spec extends Backbone.Model
  paramRoot : 'spec'

  defaults :
    avatar: null
    serial: null
    registration: null
    year: ""
    make: ""
    model_name: ""
    asking_price: 0
    description: ""
    message: null
    sent: null
    agent_website: null
    agent_email: null
    agent_phone: null
    agent_company: null  
    agent_name: null  
    agent_first: null
    images: []    
    tt: null
    tc: null
    top_average: "0:00"
    hits: 0
    last_viewed: ""
    spec_disclaimer: null
    airframe_texts: []
    
class Jetdeck.Collections.SpecsCollection extends Backbone.CollectionBook
  model: Jetdeck.Models.Spec
  url: '/xspecs'    
  
  orderBy : (o) ->
    @order = o

  direction : (d) ->
    @dx = d
    
  comparator: (i) ->
    d = 1
    d = -1 if @dx == "desc"   

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
    
