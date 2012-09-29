Jetdeck.Views.Contacts ||= {}

class Jetdeck.Views.Contacts.ShowDetails extends Backbone.View
  template: JST["templates/contacts/partials/details"]

  render: ->
    # load the tabs container
    $(@el).html(@template(@model.toJSON() ))
    
    # populate aircraft tab
    #@description = new Jetdeck.Views.Contacts.ShowDescriptionPane(model: @model)
    #@$("#pane_description").html(@description.render().el)

    # populate the notes tab
    @notes = new Jetdeck.Views.Notes.ShowNotes(model: @model)
    @$("#pane_notes").html(@notes.render().el)    

    # remove top border on first table item in spec panes
    @$(".spec_pane table").children('tbody').children('tr').first().children('td').css('border-top', '0px')

    return this

