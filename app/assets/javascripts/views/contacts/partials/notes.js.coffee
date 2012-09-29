Jetdeck.Views.Contacts ||= {}

class Jetdeck.Views.Contacts.ShowNotes extends Backbone.View
  template: JST["templates/contacts/partials/notes"]
        
  render : ->
    $(@el).html(@template())
    #@options.actions.each( (action) ->
    #  item = new Jetdeck.Views.Actions.ActionTableItem({model : action})
    #  @$("table").append(view.render().el)
    #)

    return this


