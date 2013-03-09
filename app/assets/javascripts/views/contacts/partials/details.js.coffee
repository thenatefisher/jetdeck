Jetdeck.Views.Contacts ||= {}

class Jetdeck.Views.Contacts.ShowDetails extends Backbone.View
  template: JST["templates/contacts/partials/details"]

  render: ->
    # load the tabs container
    $(@el).html(@template(@model.toJSON() ))
    
    # populate aircraft tab
    @ownership = new Jetdeck.Views.Contacts.ShowOwnership(model: @model)
    @$("#pane_aircraft").html(@ownership.render().el)

    # remove top border on first table item in spec panes
    @$(".spec_pane table").children('tbody').children('tr').first().children('td').css('border-top', '0px')

    return this

