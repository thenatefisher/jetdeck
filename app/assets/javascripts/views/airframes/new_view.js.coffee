Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.NewView extends Backbone.View
  template: JST["templates/airframes/new"]

  events:
    "click #new_airframe": "save"
    "click #import-button" : "import"

  import: =>

    @$("#error-message").hide()
    @$("#import-button").button("loading")

    $.post("/airframes/import", {
            url: @$("#import-url").val()
            authenticity_token: $("meta[name='csrf-token']").attr("content")
        }
    ).done( (a,b,c) ->
        window.location.href = a.airframe.link
    ).fail( (a,b,c) =>
        @$("#error-message").show()
        @$("#import-button").button("reset")
        @$("#error-message").html($.parseJSON(a.responseText).errors)
    )

  initialize: () ->
    @model = new Jetdeck.Models.AirframeModel()

  save: (event) =>
    event.preventDefault()
    event.stopPropagation()
    mixpanel.track("Created Airframe")
    collection = new Jetdeck.Collections.AirframesCollection()
    collection = window.router.airframes if window.router.airframes
    collection.create(@model.toJSON(),
      success: (airframe) =>
        @model = airframe
        window.location.href = "/airframes/#{@model.id}"
        modalClose()
      error: (airframe, jqXHR) =>
        errors = $.parseJSON(jqXHR.responseText)
        @$("#error-message").html(errors[0])
    )

  render: =>
    $(@el).html(@template($.merge(
        bookmarklet_url : window.bookmarklet_url, 
        @model.toJSON()) ))
    
    @$("#import_images").bind('change', => 
      if $("#import_images").is(':checked')
        $("#import_images_input").show()
      else
        delete @model.attributes.import_images
        $("#import_images_input").hide() 
    )

    @$("#upload_spec").bind('change', => 
      if $("#upload_spec").is(':checked')
        $("#upload_spec_input_container").show()
      else
        delete @model.attributes.upload_spec
        $("#upload_spec_input_container").hide() 
    )    

    @$("#airframe_headline").select2(
      placeholder: "Enter a Model",
      minimumInputLength: 3,
      id: (o) -> o.text,
      createSearchChoice: (term) ->
        return { id: term, text: term }
      ajax: 
        url: "/airframes/models.json",
        dataType: "json",
        quietMillis: 100,
        data: (term, page) ->
          return { q: term }
        results: (data) ->
          return { results: data }
    )
    @$(".airframe-headline").css("width", "300px")

    @$("form").backboneLink(@model)

    return this
