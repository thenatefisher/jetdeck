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
        window.location.href = "/airframes#/#{@model.id}"
        modalClose()

      error: (airframe, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: =>
    $(@el).html(@template(@model.toJSON() ))
    @$("#airframe_model").select2({
      placeholder: "Select a Model",
      minimumInputLength: 3
      # TODO: handle custom airframe model names
      #createSearchChoice: (term) ->
      #  return { id: -99, text: term, model_name: term }
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
    @$(".airframe-model").css('width', '250px')

    @$("#airframe_registration").autocomplete({
       minLength: 2,
       source: "/airframes",
       select: ( event, ui ) =>
          $("#airframe_registration").val(ui.item.registration) if ui.item.registration
          $("#airframe_year").val(ui.item.year) if ui.item.year
          $("#airframe_serial").val(ui.item.serial) if ui.item.serial
          @model.set('model_id', ui.item.model_id)
          @model.set('registration', ui.item.registration)
          @model.set('year', ui.item.year)
          @model.set('serial', ui.item.serial)
          $(".select2-choice").children("span").html(ui.item.make + " " + ui.item.model)
          return false
    })
    .data("autocomplete" )._renderItem = ( ul, item ) ->
       ul.addClass('dropdown-menu');
       ul.addClass('typeahead');
       return $( "<li class='result' style='cursor: pointer'></li>" )
	        .data( "item.autocomplete", item )
	        .append( "<a><strong>" + item.registration + "</strong><br>" + item.to_s + "</a>" )
	        .appendTo( ul );

    @$("form").backboneLink(@model)

    return this
