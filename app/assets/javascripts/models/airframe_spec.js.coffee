class Jetdeck.Models.AirframeSpecModel extends Backbone.Model
  paramRoot: 'airframe_spec'

  defaults:
    file_name: null
    version: null
    created_at: null
    enabled: true

class Jetdeck.Collections.AirframeSpecsCollection extends Backbone.Collection
  model: Jetdeck.Models.AirframeSpecModel
  url: '/airframe_specs'

  comparator: (i) ->
    dt = new Date(i.get("created_at"))
    return (-1)*dt