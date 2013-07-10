class Jetdeck.Models.ProfileModel extends Backbone.Model

  paramRoot: "profile"

  url: "/profile"

  defaults:
    first: null
    last: null
    email: null
    company: null
    contact: null
    website: null
    airframes: 0
    contacts: 0
    specs_sent: 0
    storage_usage: 0
    storage_quota: 0
    airframes_quota: 0
    signature: null
    help_enabled: null
    plan: null
    balance: null
    charges: null
    scheduled_amount: null
    scheduled_date: null
    card: null
    stripe_key: null
    standard_plan_available: true
    trial_time_remaining: null
