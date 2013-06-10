Jetdeck.Views.Specs = {}

class Jetdeck.Views.Specs.Send extends Backbone.View
    template: JST["templates/specs/send"]

    events:
        "change#send-spec-airframe" : "changeAircraft"
        "change#send-spec-file" : "changeSpec"
        "change#include-photos" : "includePhotos"

    render: =>
        # setup TO field
        # setup a/c field
        # setup spec field
        # add signature to body
        # select TO, ac and spec fields if specified
        $(@el).html(@template())
        return this

    includePhotos: =>

    changeAircraft: =>

    changeSpec: =>

    send: =>
        return this

