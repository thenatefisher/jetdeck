class Jetdeck.Models.LeadModel extends Backbone.Model
    paramRoot : "lead"

    defaults :
      contact: null
      airframe: null
      photos_enabled: false
      status_label: ""
      contact_label: ""
      spec_label: ""
      spec_url: ""
      status_date_label: ""
      status_time_label: ""
      messages: []
      thumbnail: "/assets/placeholder/aircraft_default_avatar_small.png"

class Jetdeck.Collections.LeadsCollection extends Backbone.Collection
  
    model: Jetdeck.Models.LeadModel
    
    url: "/leads"


    
