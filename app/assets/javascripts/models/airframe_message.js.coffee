class Jetdeck.Models.AirframeMessageModel extends Backbone.Model
    paramRoot : "airframe_message"

    defaults :
      sender: null
      spec: null
      status: null
      spec_url_code: null
      photos_url_code: null
      message_subject: null
      message_body: null
      include_photos: null
      airframe: null

class Jetdeck.Collections.AirframeMessagesCollection extends Backbone.Collection
  
    model: Jetdeck.Models.AirframeMessageModel
    
    url: "/airframe_messages"


    
