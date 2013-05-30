Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.NewView extends Backbone.View
  template: JST["templates/airframes/new"]

  events:
    "click #new_airframe": "save"

  initialize: () ->
    @model = new Jetdeck.Models.Airframe()

  save: (e) =>
    e.preventDefault()
    e.stopPropagation()
    mixpanel.track("Created Airframe")
    collection = new Jetdeck.Collections.AirframesCollection()
    collection = window.router.airframes if window.router.airframes
    collection.create(@model.toJSON(),
      success: (airframe) =>
        @model = airframe
        window.location.href = "/airframes/#{@model.id}"
        modalClose()
      error: (airframe, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
        @$("#error-message").html();
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
        $("#upload_spec_input").show()
      else
        delete @model.attributes.upload_spec
        $("#upload_spec_input").hide() 
    )    

    @$("#airframe_headline").select2({
      placeholder: "Enter a Model",
      minimumInputLength: 3,
      id: (o) -> o.text,
      createSearchChoice: (term) ->
        return { id: term, text: term }
      ajax: {
        url: "/airframes/models.json",
        dataType: "json",
        quietMillis: 100,
        data: (term, page) ->
          return { q: term }
        results: (data) ->
          return { results: data }
      }
    })
    @$(".airframe-headline").css("width", "250px")

    @$("form").backboneLink(@model)

    return this
