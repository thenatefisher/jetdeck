class Jetdeck.Models.Airframe extends Backbone.Model
  paramRoot: 'airframe'

  defaults:
    serial: null
    registration: null
    year: null

class Jetdeck.Collections.AirframesCollection extends Backbone.Collection
  model: Jetdeck.Models.Airframe
  url: '/airframes'
