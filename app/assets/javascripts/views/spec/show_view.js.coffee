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

    if $.browser != 'msie' && $.browser.version != '7.0'
      # handle IE 7 compatibility
      @$(".gallery a").photoSwipe()

    urlCode = @model.get('url_code')
    
    window.onbeforeunload = () ->
    
        endTime = new Date().getTime()
        
        timeOnPage = (endTime - window.startTime) / 1000
        
        $.post("/s", {code: urlCode, time: timeOnPage})
        
        return null
    
    return this
