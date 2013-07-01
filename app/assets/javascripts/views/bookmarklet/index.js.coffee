Jetdeck.Views.Bookmarklet ||= {}

class Jetdeck.Views.Bookmarklet.IndexView extends Backbone.View
  template: JST["templates/bookmarklet/index"]

  render : ->
    jetdeck_$(@el).html(@template({title: document.title}))
    jetdeck_$(this.el).addClass('jetdeck_success')
    return this

class Jetdeck.Views.Bookmarklet.SuccessView extends Backbone.View
  template: JST["templates/bookmarklet/success"]

  render : ->
    jetdeck_$(@el).html(@template({title: document.title}))
    jetdeck_$(this.el).addClass('jetdeck_success')
    return this    

class Jetdeck.Views.Bookmarklet.ErrorView extends Backbone.View
  template: JST["templates/bookmarklet/error"]

  render : ->
    jetdeck_$(@el).html(@template())
    jetdeck_$(this.el).addClass('jetdeck_error')
    return this
    
class Jetdeck.Views.Bookmarklet.DuplicateView extends Backbone.View
  template: JST["templates/bookmarklet/duplicate"]

  render : ->
    jetdeck_$(@el).html(@template(@options))
    jetdeck_$(this.el).addClass('jetdeck_success')
    return this    