Jetdeck.Views.Bookmarklet ||= {}

class Jetdeck.Views.Bookmarklet.IndexView extends Backbone.View
  template: JST["templates/bookmarklet/index"]

  render : ->
    $(@el).html(@template())
    $(this.el).addClass('jetdeck_success')
    return this

class Jetdeck.Views.Bookmarklet.ErrorView extends Backbone.View
  template: JST["templates/bookmarklet/error"]

  render : ->
    $(@el).html(@template())
    $(this.el).addClass('jetdeck_error')
    return this
    
class Jetdeck.Views.Bookmarklet.DuplicateView extends Backbone.View
  template: JST["templates/bookmarklet/duplicate"]

  render : ->
    $(@el).html(@template())
    return this    