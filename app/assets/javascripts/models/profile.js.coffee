class Jetdeck.Models.ProfileModel extends Backbone.Model

  paramRoot: 'profile'

  url: '/profile'

  defaults:
    first: null
    last: null
    email: null
    company: null
    contact: null
    airframes: 0
    contacts: 0
    sent: 0
    signature: null
