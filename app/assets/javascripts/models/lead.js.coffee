class Jetdeck.Models.Lead extends Backbone.Model
  paramRoot: 'lead'

  defaults:
    email: ""
    fire: false
    hits: 0
    last_viewed: ""
    recipient_id: 0
    url: "/"

class Jetdeck.Collections.LeadsCollection extends Backbone.Collection
  model: Jetdeck.Models.Lead
  url: '/leads'

  initialize : () =>
      @on('change', @updateAirframe, this)
      @on('add', @updateAirframe, this)
      @on('remove', @updateAirframe, this)

  updateAirframe : () =>
      if @airframe
          @airframe.set('leads', @toJSON())  
