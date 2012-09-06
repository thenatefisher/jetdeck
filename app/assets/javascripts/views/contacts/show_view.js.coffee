Jetdeck.Views.Contacts ||= {}

class Jetdeck.Views.Contacts.ShowView extends Backbone.View
  template: JST["templates/contacts/show"]

  events:
    "keydown .edit-group input" : "edit"
    "click .delete_contact"     : "delete"
    "click .change-cancel"      : "cancel"
    "click .change-ok"          : "save"
  
  delete: () ->
    confirm = new Jetdeck.Views.Contacts.ConfirmDelete(model: @model)
    modal(confirm.render().el)
    
  edit: (event) ->
    tgt = event.target || event.currentTarget
    $(tgt).parents(".edit-group").children(".btn-group").show()

  save: (event) ->
    tgt = event.target || event.currentTarget
    $(tgt).parents(".btn-group").hide() 
    field = $(tgt).parents(".edit-group").children("input")
    field_name = field.attr('name')
    field_value = field.val()
    undo = @model.get(field_name)
    @model.save(field_name, field_value, 
      success: => 
        $(tgt).parents(".edit-group").children(".error").hide() 
        $(tgt).parents(".edit-group").children(".updated").show()
      error: (c, jqXHR) =>
        errObj = $.parseJSON(jqXHR.responseText)
        $(tgt).parents(".edit-group").children(".updated").hide() 
        $(tgt).parents(".edit-group").children(".error").show()    
        @model.set(field_name, undo) 
        $(tgt).parents(".edit-group").
          children(".error").
          popover(
            placement: 'left', 
            title: "Error", 
            content: "Invalid Entry, Field Not Updated."
          )
    )
    
  cancel: (event) ->
    tgt = event.target || event.currentTarget
    $(tgt).parents(".btn-group").hide()
    field = $(tgt).parents(".edit-group").children("input")
    field_name = field.attr('name')
    field.val(@model.get(field_name))
    
  render: =>
    @model.fetch(
      success: () =>
        $(@el).html(@template(@model.toJSON() ))

        @header = new Jetdeck.Views.Contacts.ShowHeaderView(model: @model)
        @$("#contact_show_header").html(@header.render().el)
     )
     return this


class Jetdeck.Views.Contacts.ShowHeaderView extends Backbone.View
  template: JST["templates/contacts/partials/header"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    
    @$("#contact-name").hover(
      -> $(".edit-name").show(),
      -> $(".edit-name").hide()
    )    
    
    return this
