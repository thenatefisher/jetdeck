class Jetdeck.Models.Spec extends Backbone.Model
  paramRoot : 'spec'

  defaults :
    avatar: null
    serial: null
    registration: null
    year: ""
    listed: false
    damage: false
    tags: []
    location: null
    make: ""
    model_name: ""
    asking_price: 0
    description: ""
    message: null
    salutation: null
    show_message: false
    headline1: null
    headline2: null
    headline3: null
    override_description: null
    override_price: null
    hide_price: false        
    hide_registration: false   
    hide_serial: false   
    hide_location: false   
    background_id: null
    sent: null
    agent_website: null
    agent_email: null
    agent_phone: null
    agent_company: null  
    agent_name: null  
    images: []    
    tt: null
    tc: null
    engines: []    
    avionics: []
    equipment: []
    top_average: "0:00"
    hits: 0
    last_viewed: ""
    logo: null
    
class Jetdeck.Collections.SpecsCollection extends Backbone.CollectionBook
  model: Jetdeck.Models.Spec
  url: '/xspecs'    
  
  orderBy : (o) ->
    @order = o

  direction : (d) ->
    @dx = d
    
