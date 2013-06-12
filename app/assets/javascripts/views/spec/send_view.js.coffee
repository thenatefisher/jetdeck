Jetdeck.Views.Specs = {}

class Jetdeck.Views.Specs.Send extends Backbone.View
    template: JST["templates/specs/send"]

    events:
        "change#spec-send-airframe" : "changeAircraft"
        "change#spec-send-file" : "changeSpec"
        "change#include-photos" : "includePhotos"

    setupToField: =>
      @$('#spec-send-email').autocomplete({
        minLength: 2
        autofocus: true
        focus: (event, ui) =>
          $("#spec-send-email").val(ui.item.value) if ui.item.value
          event.preventDefault()
        select: ( event, ui ) =>
          $("#spec-send-email").val(ui.item.value) if ui.item.value
          return false
        source: "/contacts/search"
      }).data("uiAutocomplete")._renderItem = ( ul, item ) ->
        ul.addClass("dropdown-menu")
        ul.addClass("typeahead")
        return $( "<li class=\"result\" style=\"cursor: pointer\"></li>" )
          .data( "item.autocomplete", item )
          .append( "<a><strong>" + item.label + "</strong></a>" )
          .appendTo( ul )

    setupAircraftField: =>
        @$("#spec-send-airframe").select2(
          placeholder: "Aircraft"
          minimunInputLength: 0
          ajax:
            url: "/airframes.json"
            dataType: "json"
            results: (data) ->
              return {results: data.to_s}
        )
        @$("#spec-send-airframe").css("width", "180px")

    render: =>
        $(@el).html(@template())
        # setup TO field
        $( => 
          @setupToField()
          @setupAircraftField() 
        )
        # setup a/c field
        # setup spec field
        # add signature to body
        # select TO, ac and spec fields if specified
        return this

    includePhotos: =>

    changeAircraft: =>

    changeSpec: =>

    send: =>
        return this

