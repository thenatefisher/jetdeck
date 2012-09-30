class Jetdeck.Models.Profile extends Backbone.Model

  paramRoot: 'profile'

  url: '/profile'

  defaults:
    type: null
    first: null
    last: null
    email: null
    company: null
    contact: null
    airframes: 0
    contacts: 0
    sent: 0
    views: 0
    spec_disclaimer: null
    logo: null
