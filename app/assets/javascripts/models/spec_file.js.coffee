class Jetdeck.Models.SpecFileModel extends Backbone.Model
  paramRoot: 'accessory'

  defaults:
    file_name: null
    version: null
    created_at: null
    enabled: true

class Jetdeck.Collections.SpecFilesCollection extends Backbone.Collection
  model: Jetdeck.Models.SpecFileModel
  url: '/accessories'

  comparator: (i) ->
    dt = new Date(i.get("created_at"))
    return (-1)*dt