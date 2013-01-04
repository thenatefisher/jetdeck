class Jetdeck.Models.MatchModel extends Backbone.Model
    paramRoot: "match"
    
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

class Jetdeck.Collections.MatchesCollection extends Backbone.Collection
    model: Jetdeck.Models.MatchModel
    url: "/matches"
    
    initialize : () =>
      @on('change', @updateAirframe)
      
    updateAirframe : () =>
        if @airframe
            @airframe.set('matches', @toJSON())
