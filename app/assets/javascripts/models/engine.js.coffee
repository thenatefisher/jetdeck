class Jetdeck.Models.EngineModel extends Backbone.Model
    paramRoot: "engine"
    
    defaults:
        label: null
        make: null
        model: null
        id: null

class Jetdeck.Collections.EnginesCollection extends Backbone.Collection
    model: Jetdeck.Models.EngineModel
    url: "/engines"
    
    initialize : () =>

    updateAirframe : () =>
        if @airframe
            @airframe.set('engines', @toJSON())
