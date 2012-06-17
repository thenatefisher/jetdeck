class Jetdeck.Models.Profile extends Backbone.Model
  paramRoot: 'user'

  defaults:
    type: null
    first: null
    last: null
    email: null
    airframes: 0
    contacts: 0
    sent: 0
    views: 0
