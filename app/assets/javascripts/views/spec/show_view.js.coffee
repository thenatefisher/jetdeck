Jetdeck.Views.Spec ||= {}

class Jetdeck.Views.Spec.ShowView extends Backbone.View
  template: JST["templates/spec/show"]

  events: 
    "click #close-message"  : "closeMessage"
    
  closeMessage : ->
    if $("#dont-show-message").is(":checked")
      @model.collection = new Jetdeck.Collections.SpecsCollection()
      @model.save({show_message: 'false'})
      
  render: ->
    $(@el).html(@template(@model.toJSON() ))
    @$('.carousel').carousel()
    @$('.carousel').hover(() ->
        $('.carousel-control').fadeIn('fast')
      () ->
        $('.carousel-control').fadeOut('fast')
    )
    @$('.hero-image').click(() ->
      imgsrc = $(this).data('spec_lightbox')
      orignsrc = $(this).data('original')
      $("#image-modal").children(".modal-body").html(
        "<a target='_blank' href='" + orignsrc + "'>
        <img class='center-block pop-image' src='" + imgsrc + "'></a>")
      $("#image-modal > .modal-footer").html(
        "<button class='btn' data-dismiss='modal'>Close</button>
        <a target='_blank' href=" + orignsrc + " class='btn'><i class='icon-download-alt'></i> Get Full-Res</a>"
      )
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
