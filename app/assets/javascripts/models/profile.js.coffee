class Jetdeck.Models.ProfileModel extends Backbone.Model

  paramRoot: 'profile'

  url: '/profile'

  defaults:
    first: null
    last: null
    email: null
    company: null
    contact: null
    website: null
    airframes: 0
    contacts: 0
    sent: 0
    storage_usage: 0
    storage_quota: 0
    signature: null
    help_enabled: null
