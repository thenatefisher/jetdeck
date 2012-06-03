Jetdeck.Views.Contacts ||= {}

class Jetdeck.Views.Contacts.ShowView extends Backbone.View
  template: JST["templates/contacts/show"]
  
  render: =>
    @model.fetch(
      success: () =>
        $(@el).html(@template(@model.toJSON() ))

        @header = new Jetdeck.Views.Contacts.ShowHeaderView(model: @model)
        @$("#contact_show_header").html(@header.render().el)        
     )
     return this
     

class Jetdeck.Views.Contacts.ShowHeaderView extends Backbone.View
  template: JST["templates/contacts/partials/_header"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
     
