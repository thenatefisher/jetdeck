Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.NewView extends Backbone.View
  template: JST["templates/airframes/new"]

  events:
    "click #new_airframe": "save"

  initialize: () ->
    @model = new Jetdeck.Models.Airframe()

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    collection = new Jetdeck.Collections.AirframesCollection()
    collection = window.router.airframes if window.router.airframes
    collection.create(@model.toJSON(),
      success: (airframe) =>
        @model = airframe
        window.location.href = "/airframes/#{@model.id}"
        modalClose()

      error: (airframe, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: =>
    $(@el).html(@template(@model.toJSON() ))
    
    @$("#airframe_headline").select2({
      placeholder: "Enter a Model",
      minimumInputLength: 3,
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

    @$("#airframe_registration").autocomplete({
       minLength: 2,
       autofocus: true,
       focus: (event, ui) ->
          $("#airframe_registration").val(ui.item.registration) if ui.item.registration
          $("#airframe_year").val(ui.item.year) if ui.item.year
          $("#airframe_serial").val(ui.item.serial) if ui.item.serial
          @model.set("baseline_id", ui.item.id)
          @model.set("registration", ui.item.registration)
          @model.set("year", ui.item.year)
          @model.set("serial", ui.item.serial)
          $(".select2-choice").children("span").html(ui.item.make + " " + ui.item.modelName)
          event.preventDefault(); # Prevent the default focus behavior.
       source: "/airframes",
       select: ( event, ui ) =>
          $("#airframe_registration").val(ui.item.registration) if ui.item.registration
          $("#airframe_year").val(ui.item.year) if ui.item.year
          $("#airframe_serial").val(ui.item.serial) if ui.item.serial
          @model.set("baseline_id", ui.item.id)
          @model.set("registration", ui.item.registration)
          @model.set("year", ui.item.year)
          @model.set("serial", ui.item.serial)
          $(".select2-choice").children("span").html(ui.item.make + " " + ui.item.modelName)
          return false
    })
    .data("autocomplete" )._renderItem = ( ul, item ) ->
       ul.addClass("dropdown-menu");
       ul.addClass("typeahead");
       return $( "<li class=\"result\" style=\"cursor: pointer\"></li>" )
	        .data( "item.autocomplete", item )
	        .append( "<a><strong>" + item.registration + "</strong><br>" + item.to_s + "</a>" )
	        .appendTo( ul );

    @$("form").backboneLink(@model)

    return this
