class Jetdeck.Models.EquipmentModel extends Backbone.Model
    paramRoot: "equipment"

class Jetdeck.Collections.EquipmentCollection extends Backbone.Collection
    model: Jetdeck.Models.EquipmentModel
    url: "/equipment"
    
    initialize : () =>
        @on('change', @updateAirframe, this)
        @on('add', @updateAirframe, this)
        @on('remove', @updateAirframe, this)

    updateAirframe : () =>
        if @airframe
            @airframe.set('equipment', @toJSON())
