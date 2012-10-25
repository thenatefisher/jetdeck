Jetdeck.Views.Airframes ||= {}

# This is a pane inside the specification tab container

class Jetdeck.Views.Airframes.ShowDescriptionPane extends Backbone.View
  template: JST["templates/airframes/spec/description/pane"]
    
  render: ->
    $(@el).html(@template(@model.toJSON() ) )
    
    @$("textarea[name='description']").wysihtml5(
	    "font-styles": false
	    "emphasis": true
	    "lists": true
	    "html": false
	    "link": false
	    "image": false
	    "color": false  
	    "events": 
	      "change": ->
	        window.router.view.edit()
	      "newword:composer": ->
	        window.router.view.edit()	        
	      "paste": ->
	        window.router.view.edit()	             
    )

    return this
