Jetdeck.Views.Specs ||= {}

class Jetdeck.Views.Specs.DisableConfirmation extends Backbone.View
  template: JST["templates/specs/disable_confirmation"]

  render: =>
    $(@el).html(@template())
    @$("#disable").on("click", => @trigger("clicked-disable"); modalClose())
    return this
