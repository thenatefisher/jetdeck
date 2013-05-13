Jetdeck.Views.Bookmarklet ||= {}

class Jetdeck.Views.Bookmarklet.IndexView extends Backbone.View
  template: JST["templates/bookmarklet/index"]

  events:
    "click #jetdeck_close" : close_jetdeck

  render : ->
    jetdeck_$(@el).html(@template({title: document.title}))
    jetdeck_$(this.el).addClass('jetdeck_success')
    return this

class Jetdeck.Views.Bookmarklet.SuccessView extends Backbone.View
  template: JST["templates/bookmarklet/success"]

  events:
    "click #jetdeck_close" : close_jetdeck

  render : ->
    jetdeck_$(@el).html(@template({title: document.title}))
    jetdeck_$(this.el).addClass('jetdeck_success')
    return this    

class Jetdeck.Views.Bookmarklet.ErrorView extends Backbone.View
  template: JST["templates/bookmarklet/error"]

  events:
    "click #jetdeck_close" : close_jetdeck

  render : ->
    jetdeck_$(@el).html(@template())
    jetdeck_$(this.el).addClass('jetdeck_error')
    return this
    
class Jetdeck.Views.Bookmarklet.DuplicateView extends Backbone.View
  template: JST["templates/bookmarklet/duplicate"]

  events:
    "click #jetdeck_close" : close_jetdeck

  render : ->
    jetdeck_$(@el).html(@template(@options))
    jetdeck_$(this.el).addClass('jetdeck_success')
    return this    