class Jetdeck.Models.LeadModel extends Backbone.Model
    paramRoot : "lead"

    defaults :
      contact: null
      airframe: null
      thumbnail: "/assets/placeholder/aircraft_default_avatar_small.png"

class Jetdeck.Collections.LeadsCollection extends Backbone.Collection
  
    model: Jetdeck.Models.LeadModel
    
    url: "/leads"


    
