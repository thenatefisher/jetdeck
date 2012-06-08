Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.NewView extends Backbone.View
  template: JST["templates/airframes/new"]

  events:
    "submit #new-airframe": "save"
    "change .airframe_registration" : "registration"

  registration : () ->
    # clean up any old validation
    @$(".registration_group").removeClass("error").children(".help-block").hide()
    # hit server for a search
    $.get("/airframes", {baseline_registration: @$(".airframe_registration").val()})
    .success( (airframe) =>
         # if found, fill out fields
         @$(".airframe_year").val(airframe.year) if airframe.year
         @$(".airframe_model").val(airframe.to_s) if airframe.to_s
         @$(".airframe_serial").val(airframe.serial) if airframe.serial
         return true
    )
    .error( =>
         @$(".registration_group").addClass("error").children(".help-block").show()
    )

  initialize: () ->
    @model = new Jetdeck.Models.Airframe()

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @collection.create(@model.toJSON(),
      success: (airframe) =>
        @model = airframe
        #window.location.hash = "/#{@model.id}"

      error: (airframe, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
