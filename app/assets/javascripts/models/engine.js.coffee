class Jetdeck.Models.EngineModel extends Backbone.Model
    paramRoot: "engine"
    
    defaults:
        label: null
        make: null
        model: null
        id: null
        model_name: null
        tt: null
        tc: null
        smoh: null
        shsi: null
        pending: false

class Jetdeck.Collections.EnginesCollection extends Backbone.Collection
    model: Jetdeck.Models.EngineModel
    url: "/engines"
    
    initialize : () =>
      @on('change', @updateAirframe)
      
    updateAirframe : () =>
        if @airframe
            @airframe.set('engines', @toJSON())
