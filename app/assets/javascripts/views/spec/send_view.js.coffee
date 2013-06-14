Jetdeck.Views.Specs = {}

class Jetdeck.Views.Specs.Send extends Backbone.View
    template: JST["templates/specs/send"]

    setupToField: =>
        @$('#email').autocomplete({
            minLength: 2
            autofocus: true
            focus: (event, ui) =>
                $("#email").val(ui.item.value) if ui.item.value
                event.preventDefault()
            select: ( event, ui ) =>
                $("#email").val(ui.item.value) if ui.item.value
                @setupBodyField()
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
        aircraft_collection = new Jetdeck.Collections.AirframesCollection()
        aircraft_collection.fetch(success: =>

            data = aircraft_collection.reduce(
                (a,b) -> 
                    return a.concat({
                        id: b.get('id'), 
                        text: b.get('long'),
                        airframe: b
                    }) 
                , [])

            @$("#airframe").select2(
                placeholder: "Aircraft"
                data: data
            )

            @$("#airframe").on("select2-selecting", (val) => @airframeSelected(val))

        )

    airframeSelected: (val) =>
        # show spec options
        @setupSpecField(val.object.airframe)
        # show photos include checkbox
        # update subject and body

    setupSpecField: (airframe) =>
        airframe.fetch(success: =>
            airframe.updateChildren()
            if airframe.specs.length > 0

                data = airframe.specs.reduce(
                    (a,b) -> 
                        return a.concat({
                            id: b.get('id'), 
                            filename: b.get('file_name'), 
                            text: b.get('file_name').trunc(40) + " v" + (parseInt(b.get('version'))+1)
                        }) 
                    , [])

                @$("#spec").select2(
                    placeholder: "Spec"
                    data: data

                )

                @$("#spec").on("select2-selecting", (val) => @specSelected(val))
                
        )

    specSelected: (val) =>
        # update spec file indicator class
        # and content
        # show attachment icon
        @$("#attachment-filename").html(val.object.filename.rtrunc(38))

    setupBodyField: =>
        # add recipient name
        # add boilerplate message
        # enter signature into message body

    render: =>
        $(@el).html(@template())

        # create autosuggest and select2 fields
        # populate body with signature
        $( => 
          @setupToField()
          @setupAircraftField() 
          @setupBodyField()
        )

        return this

    includePhotos: =>
        @$("#attachment-photos-link").show()
        

    send: =>
        return this

