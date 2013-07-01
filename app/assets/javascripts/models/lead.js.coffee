class Jetdeck.Models.LeadModel extends Backbone.Model
    paramRoot : "lead"

    defaults :
      contact: null
      airframe: null

class Jetdeck.Collections.LeadsCollection extends Backbone.Collection
  
    model: Jetdeck.Models.LeadModel
    
    url: "/leads"


    
