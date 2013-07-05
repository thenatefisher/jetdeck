Jetdeck.Views.Bookmarklet ||= {}

class Jetdeck.Views.Bookmarklet.IndexView extends Backbone.View
  template: JST["templates/bookmarklet/index"]
  
  render : ->
    jetdeck_$(@el).html(@template({title: document.title}))
    jetdeck_$(this.el).addClass('jetdeck_success')
    jetdeck_$("#jetdeck_close", this.el).click( -> window.close_jetdeck())
    return this

class Jetdeck.Views.Bookmarklet.SuccessView extends Backbone.View
  template: JST["templates/bookmarklet/success"]

  render : ->
    jetdeck_$(@el).html(@template({title: document.title}))
    jetdeck_$(this.el).addClass('jetdeck_success')
    jetdeck_$("#jetdeck_close", this.el).click( -> window.close_jetdeck())
    return this    

class Jetdeck.Views.Bookmarklet.ErrorView extends Backbone.View
  template: JST["templates/bookmarklet/error"]

  render : ->
    jetdeck_$(@el).html(@template())
    jetdeck_$(this.el).addClass('jetdeck_error')
    jetdeck_$("#jetdeck_close", this.el).click( -> window.close_jetdeck())
    return this
    
class Jetdeck.Views.Bookmarklet.DuplicateView extends Backbone.View
  template: JST["templates/bookmarklet/duplicate"]

  render : ->
    jetdeck_$(@el).html(@template(@options))
    jetdeck_$(this.el).addClass('jetdeck_success')
    jetdeck_$("#jetdeck_close", this.el).click( -> window.close_jetdeck())
    return this    

class Jetdeck.Views.Bookmarklet.OwnGoalView extends Backbone.View
  template: JST["templates/bookmarklet/own_goal"]

  render : ->
    jetdeck_$(@el).html(@template(@options))
    jetdeck_$(this.el).addClass('jetdeck_error')
    jetdeck_$("#jetdeck_close", this.el).click( -> window.close_jetdeck())
    return this    