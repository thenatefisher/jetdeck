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
                @recipient = ui.item.label if ui.item.label != ui.item.value
                @setupEmailFields()
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

    reset: () =>
        # reset send button
        @$("#send").button('reset')           
        # clear errors
        @$("#error-message").html("")
        # disabled send button
        @validateForm()
        # clear spec selected
        @clearSpecSelected()
        # hide no specs message
        @$("#nospecs").hide()
        # hide photos include checkbox
        @$("label[for='include-photos']").hide()        
        # hide and clear spec options
        @$("#spec").val(null)
        @$("#spec").data("select2").destroy() if @$("#spec").data("select2")
        # clear email content fields if they were not edited by user
        @clearEmailFields()

    airframeSelected: (val) =>
        # reset form state
        @reset()
        # fetch aircraft and act accordingly
        @airframe = val.object.airframe
        @airframe.fetch(success: =>
            @airframe.updateChildren()
            @setupEmailFields()
            if @airframe.specs.length > 0        
                # show spec options if specs exist
                @setupSpecField(@airframe)
                # check if photos exist
                if @airframe.get('avatar')
                    # show photos include checkbox if photos exist
                    @$("label[for='include-photos']").show()   
            else
                @$("#nospecs").show()
        )

    setupSpecField: (airframe) =>
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

    clearSpecSelected: (val) =>
        # update spec file indicator class
        @$("#attachment-filename").removeClass("selected")
        # remove content
        @$("#attachment-filename").html("Select a Spec File to Send <i class='icon-circle-arrow-up'></i>")
        # hide attachment icon
        @$("#attachment-icon").hide()
        # hide images checked
        $("#attachment-photos-link").hide()

    specSelected: (val) =>
        # update spec file indicator class
        @$("#attachment-filename").addClass("selected")
        # and content
        @$("#attachment-filename").html(val.object.filename.rtrunc(38))
        # show attachment icon
        @$("#attachment-icon").show()
        # fill in email content fields
        @setupEmailFields()
        # show images link
        @showPhotosLink()

    showPhotosLink: =>
        if $("label[for='include-photos'] input").is(":checked")
            $("#attachment-photos-link").show() 
        else
            $("#attachment-photos-link").hide() 

    validateForm: =>
        if @$("#spec").val() != "" and
            @$("#email").val() != ""
                @$("#send").removeAttr("disabled")
        else
            @$("#send").attr("disabled", "disabled");

    clearEmailFields: =>
        @$("#message-body").val("") if !(@touchedBody)
        @$("#message-subject").val("") if !(@touchedSubject)

    setupEmailFields: =>
        # update subject
        subject = ""
        subject += "#{@airframe.get('long')}" if (@airframe and @airframe.get('long')?)
        @$("#message-subject").val(subject) if !(@touchedSubject)
        #crete message
        message = ""
        # add recipient name
        message += "#{@recipient},\n\n" if @recipient?
        # add boilerplate message
        message += "Please review the attached document regarding the #{@airframe.get('to_s')}. Thank you,\n\n" if (@airframe and @airframe.get('to_s')?)
        # enter signature into message body
        message = "\n\n\n" if message == ""
        message += @profile.get('signature') if @profile.get('signature')?
        # enter body if user hasnt edited it
        @$("#message-body").val(message) if !(@touchedBody)

    initialize: =>
        @airframe = null
        @recipient = null
        @touchedSubject = false
        @touchedBody = false
        @profile = new Jetdeck.Models.ProfileModel()
        @profile.fetch(success: => @setupEmailFields())

    render: =>
        $(@el).html(@template())

        # wait for DOM to finish loading
        $( => 

          @setupToField()
          @setupAircraftField() 
          @setupEmailFields()

          @$("#message-body").on("keyup", => @touchedBody = true)
          @$("#message-subject").on("keyup", => @touchedSubject = true)
          @$("#spec").on("change", => @validateForm())
          @$("#email").on("change keyup", => @validateForm())
          @$("label[for='include-photos'] input").on("change", => @showPhotosLink())
          @$("#send").on("click", => @send())

        )

        # create a lead and connect form fields to it
        @lead = new Jetdeck.Models.LeadModel()
        @$("form").backboneLink(@lead)

        return this
        
    send: =>
        # todo - start default state from a send button
        # todo - handle errors on send

        # set send button to spinner
        @$("#send").button('loading')

        @lead.set(
            "recipient_email"   : @$("#email").val()
            "message_subject"   : @$("#message-subject").val()
            "message_body"      : @$("#message-body").val()
            "include_photos"    : @$("#include-photos").is(":checked") 
        )

        leads_collection = new Jetdeck.Collections.LeadsCollection()
        leads_collection.create(@lead,
            success: =>
                # reset send button
                @$("#send").button('reset')
                window.modalClose()   
            error: (o,response) =>
                errors = $.parseJSON(response.responseText)
                @$("#error-message").html(errors[0])
                # reset send button
                @$("#send").button('reset')                   
        )

        return this

