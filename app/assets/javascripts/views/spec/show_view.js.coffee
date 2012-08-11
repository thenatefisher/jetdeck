Jetdeck.Views.Spec ||= {}

class Jetdeck.Views.Spec.ShowView extends Backbone.View
  template: JST["templates/spec/show"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    @$('.carousel').carousel()
    @$('.carousel').hover(() ->
        $('.carousel-control').fadeIn('fast')
      () ->
        $('.carousel-control').fadeOut('fast')
    )
    @$('.hero-image').click(() ->
      imgsrc = $(this).data('original')
      $("#image-modal").children(".modal-body").html("<img src='" + imgsrc + "'>")
      $("#image-modal").modal("show")
    )
    @$('#message-seller').click(() ->
      $("#message-modal").modal("show")
    )

    urlCode = @model.get('url_code')
    
    window.onbeforeunload = () ->
    
        endTime = new Date().getTime()
        
        timeOnPage = (endTime - window.startTime) / 1000
        
        $.post("/s", {code: urlCode, time: timeOnPage})
        
        return null
    
    return this
