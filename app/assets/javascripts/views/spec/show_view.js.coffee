Jetdeck.Views.Spec ||= {}

class Jetdeck.Views.Spec.ShowView extends Backbone.View
  template: JST["templates/spec/show"]

  events: 
    "click #close-message"  : "closeMessage"
    
  initialize: ->
    mixpanel.track_links(".contact-email", "Contact Button Clicked", {type: 'email'})  
    mixpanel.track_links(".contact-phone", "Contact Button Clicked", {type: 'phone'})  
    
  closeMessage : ->
    if $("#dont-show-message").is(":checked")
      @model.collection = new Jetdeck.Collections.SpecsCollection()
      @model.save({show_message: 'false'})
      mixpanel.track("Customer Closed Broker Message", {permanently: true})
      
    mixpanel.track("Customer Closed Broker Message", {permanently: false})  

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    mixpanel.track("Retail Spec Viewed")

    urlCode = @model.get('url_code')
    
    window.onbeforeunload = () ->
    
        endTime = new Date().getTime()
        
        timeOnPage = (endTime - window.startTime) / 1000
        
        $.post("/s", {code: urlCode, time: timeOnPage})
        
        return null
    
    return this
