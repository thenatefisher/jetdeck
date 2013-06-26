class Jetdeck.Models.AirframeImageModel extends Backbone.Model
  paramRoot: 'airframe_image'

  defaults:
    file_name: null
    version: null
    created_at: null
    enabled: true

class Jetdeck.Collections.AirframeImagesCollection extends Backbone.Collection
  model: Jetdeck.Models.AirframeImageModel
  url: '/airframe_images'

  comparator: (i) ->
    dt = new Date(i.get("created_at"))
    return (-1)*dt