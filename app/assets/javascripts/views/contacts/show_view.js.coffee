Jetdeck.Views.Contacts ||= {}

class Jetdeck.Views.Contacts.ShowView extends Backbone.View
  template: JST["templates/contacts/show"]

  events:
    "keydown .inline-edit"      : "edit"
    "click .change-cancel"      : "cancel"
    "click .change-ok"          : "save"
  
  initialize: =>
    $("#cancel-changes").on("click", @cancel)
    $("#save-changes").on("click", @save)
    
  cancel: (e) =>
    e.preventDefault()
    $("#changes").children().fadeOut()
    $("#changes").slideUp(=>
      @model.fetch( success: =>
        @render()
      )
    )
    
  edit: (event) ->
    element = event.target || event.currentTarget 
    $(element).addClass("changed")
    $("#changes").children().fadeIn()
    $("#changes").slideDown()
  
 
  save: (e) =>
    $("#save-changes").prop('disabled', true)
    $(".error").html("")
    self = this
    
    $(".inline-edit").each( ->
      
      # strip leading/trailing space
      this.value = this.value.replace(/(^\s*)|(\s*$)/gi,"")
      this.value = this.value.replace(/\n /,"\n")

      self.model.attributes[this.name] = this.value
      
    )
    
    @model.save(null,
      success: (response) =>
        $("#changes").children().fadeOut()
        $("#changes").slideUp(=>
          window.router.view.render()
          alertSuccess("<i class='icon-ok icon-large'></i> Changes Saved!") 
        )
        mixpanel.track("Updated Contact")

      error: (model, error) =>
        alertFailure(
          "<i class='icon-warning-sign icon-large'></i> Error Saving Changes"
        )
        errorStruct = JSON.parse(error.responseText)      
        $(".error[for='"+e+"']").html(errorStruct[e].toString()) for e of errorStruct

    )
    
    $("#save-changes").prop('disabled', false)
    
  render: =>
    lastDetailTab = null
    if $("#contact_details .tab-pane:visible").attr("id")
      lastDetailTab = $("#contact_details .tab-pane:visible").attr("id")
          
    $(@el).html(@template(@model.toJSON() ))

    @header = new Jetdeck.Views.Contacts.ShowHeaderView(model: @model)
    @$("#contact_show_header").html(@header.render().el)
    
    @specs = new Jetdeck.Views.Contacts.ShowSpecs(model: @model)
    if @model.specs.length > 0
      @$("#contact_specs").html(@specs.render().el) 

    @actions = new Jetdeck.Views.Actions.ShowActions(model: @model)
    @$("#contact_actions").html(@actions.render().el)  
    
    @delete = new Jetdeck.Views.Contacts.ShowDelete(model: @model)
    @$("#contact_delete").html(@delete.render().el)
        
    @details = new Jetdeck.Views.Contacts.ShowDetails(model: @model)
    @$("#contact_details").html(@details.render().el)
    @$("a[href='#"+lastDetailTab+"']'").tab('show') if lastDetailTab  
    
    return this


class Jetdeck.Views.Contacts.ShowHeaderView extends Backbone.View
  template: JST["templates/contacts/partials/header"]

  addCustomDetails: =>
    @model.custom_details.each (i) =>
      item_view = new Jetdeck.Views.Contacts.CustomDetailItem(model: i)
      @$(".contact-header-details tbody").append(item_view.render().el)

  render: ->
    $(@el).html(@template(@model.toJSON() )) 
    @addCustomDetails()
    return this
