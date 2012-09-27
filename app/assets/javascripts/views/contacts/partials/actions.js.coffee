Jetdeck.Views.Contacts ||= {}

class Jetdeck.Views.Contacts.ShowActions extends Backbone.View
  template: JST["templates/contacts/partials/actions"]
        
  render : ->
    $(@el).html(@template())
    #@options.actions.each( (action) ->
    #  item = new Jetdeck.Views.Actions.ActionTableItem({model : action})
    #  @$("table").append(view.render().el)
    #)

    return this

