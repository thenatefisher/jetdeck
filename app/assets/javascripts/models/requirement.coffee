class Jetdeck.Models.RequirementModel extends Backbone.Model
    paramRoot: "requirement"

    defaults:
      name: null


class Jetdeck.Collections.RequirementsCollection extends Backbone.CollectionBook

    model: Jetdeck.Models.RequirementModel
    
    url: "/requirements"
    
    initialize : () =>
        @on('change', @updateParent, this)
        @on('add', @updateParent, this)
        @on('remove', @updateParent, this)

    updateParent : () =>
        if @contact
            @contact.set('requirements', @toJSON())
