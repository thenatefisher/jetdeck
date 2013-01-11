class Jetdeck.Models.AlertModel extends Backbone.Model
    paramRoot: "alert"

    defaults:
      name: null


class Jetdeck.Collections.AlertsCollection extends Backbone.CollectionBook

    model: Jetdeck.Models.AlertModel
    
    url: "/alerts"
    
    initialize : () =>
        @on('change', @updateParent, this)
        @on('add', @updateParent, this)
        @on('remove', @updateParent, this)

    updateParent : () =>
        if @contact
            @contact.set('alerts', @toJSON())
