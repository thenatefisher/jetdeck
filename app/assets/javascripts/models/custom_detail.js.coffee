class Jetdeck.Models.CustomDetailModel extends Backbone.Model
    paramRoot: "detail"

    defaults:
      name: null
      value: null
      id: null

class Jetdeck.Collections.CustomDetailsCollection extends Backbone.Collection

    model: Jetdeck.Models.CustomDetailModel
    
    url: "/details"
    
    initialize : () =>
        @on('change', @updateParent, this)
        @on('add', @updateParent, this)
        @on('remove', @updateParent, this)

    updateParent : () =>
        if @contact
            @contact.set('custom_details', @toJSON())
