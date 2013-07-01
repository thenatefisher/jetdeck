class Jetdeck.Models.LeadModel extends Backbone.Model
    paramRoot : "lead"

    defaults :
      recipient: null
      airframe: null
      sender: null
      spec: null
      status: null
      spec_url_code: null
      photos_url_code: null
      message_subject: null
      message_body: null
      include_photos: null

class Jetdeck.Collections.LeadsCollection extends Backbone.Collection
  
    model: Jetdeck.Models.LeadModel
    
    url: "/leads"


    
