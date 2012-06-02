Jetdeck.Views.Contacts ||= {}

class Jetdeck.Views.Contacts.ShowView extends Backbone.View
  template: JST["templates/contacts/show"]
  
  render: =>
    @model.fetch(
      success: () =>
        $(@el).html(@template(@model.toJSON() ))
     )
     return this
