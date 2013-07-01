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
        ac_collection_data = @aircraft_collection.reduce(
            (a,b) -> 
                return a.concat({
                    id: b.get('id'), 
                    text: b.get('long'),
                    airframe: b
                }) 
            , [])
        console.log ac_collection_data
        @$("#airframe").ready( =>
            @$("#airframe").select2(
                placeholder: "Select Aircraft"
                data: ac_collection_data
                initSelection: (element, callback) =>
                    id = parseInt(element.val())
                    airframe = @aircraft_collection.where({id: id})[0]
                    if airframe?
                        text = airframe.get('long')
                    else
                        text = "Select Aircraft"
                        $("#airframe").select2("val", null)                    
                    data = 
                        id: id
                        text: text
                        airframe: airframe
                    callback(data)
            )
            @$(".airframe").css('width', '380px')
            @$("#airframe").on("select2-selecting", (val) => @airframeSelected(val.object.airframe))
            if (@options && @options.airframe) 
                # select airframe
                @$("#airframe").select2("val", @options.airframe.get("id"))
                @airframeSelected(@options.airframe)
        )

    reset: () =>
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
        @airframe = val
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
                    $("#attachment-photos-link").show() 
            else
                @$("#nospecs").show()
            @validateForm()
        )

    setupSpecField: (airframe) =>
        data = airframe.specs.reduce(
            (a,b) -> 
                return a.concat({
                    id: b.get('id'), 
                    spec: b, 
                    text: b.get('file_name').trunc(40) 
                }) 
            , [])

        @$("#spec").select2(
            placeholder: "Select Spec File"
            data: data
            initSelection: (element, callback) =>
                id = parseInt(element.val())
                spec = airframe.specs.where({id: id})[0]
                if spec?
                    text = spec.get('file_name').trunc(40)
                else
                    text = "Select Spec File"
                    $("#spec").select2("val", null)
                data = 
                    id: id
                    text: text
                    spec: spec
                callback(data)
        )

        @$("#spec").on("select2-selecting", (val) => @specSelected(val.object.spec))
        if (@useDefaultSpec && @options && @options.spec) 
            @useDefaultSpec = false
            @$("#spec").select2("val", @options.spec.get("id"))
            @specSelected(@options.spec)        

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
        @$("#attachment-filename").html(val.get('file_name').rtrunc(38))
        # show attachment icon
        @$("#attachment-icon").show()
        # fill in email content fields
        @setupEmailFields()
        # show images link
        @showPhotosLink()
        # validate
        @validateForm()

    showPhotosLink: =>
        if $("label[for='include-photos'] input").is(":visible") && 
          $("label[for='include-photos'] input").is(":checked")
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
        message += "#{@recipient},<br><br>" if @recipient?
        # add boilerplate message
        message += "Please review the attached document regarding the #{@airframe.get('to_s')}. Thank you,<br><br>" if (@airframe and @airframe.get('to_s')?)
        # enter signature into message body
        message = "<br><br><br>" if message == ""
        message += @signature if @signature?
        # enter body if user hasnt edited it
        @$("#message-body").html(message) if !(@touchedBody)

    initialize: =>
        # state
        @useDefaultSpec = true
        @airframe = null 
        @recipient = null
        @touchedSubject = false
        @touchedBody = false
        # setup a/c collection 
        @aircraft_collection = new Jetdeck.Collections.AirframesCollection()
        @aircraft_collection.reset window.data.airframe_index
        # signature
        @signature = window.data.signature

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
        # set send button to spinner
        @$("#send").button('loading')

        @lead.set(
            "recipient_email"   : @$("#email").val()
            "airframe_id"       : @$("#airframe").val()
            "spec_id"           : @$("#spec").val()
            "message_subject"   : @$("#message-subject").val()
            "message_body"      : @$("#message-body").val()
            "include_photos"    : @$("#include-photos").is(":checked") && @$("#include-photos").is(":visible") 
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

