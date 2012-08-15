Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.ShowView extends Backbone.View
  template: JST["templates/airframes/show"]

  events:
    "change .inline-edit"       : "edit"
    "click .manage_images"      : "manageImages"
    "click .delete_spec"        : "deleteSpec"

  deleteSpec: () ->
    confirm = new Jetdeck.Views.Airframes.ConfirmDelete(model: @model)
    modal(confirm.render().el)
      
  manageImages: () ->
    if $("#uploader").is(":visible")
      $("#uploader").hide()
      $(".manage_images").html("Manage Images")
    else
      $("#uploader").show()
      $(".manage_images").html("Hide Images")
      
  edit: (event) ->
    e = event.target || event.currentTarget
    
    if $(e).hasClass('number')
      value = parseInt($(e).val().replace(/[^0-9]/g,""), 10)
      $(e).val(value.formatMoney(0, ".", ","))
    else if $(e).hasClass('money')
      value = parseInt($(e).val().replace(/[^0-9]/g,""), 10)
      $(e).val("$"+value.formatMoney(0, ".", ","))
    else
      value = $(e).val()

    name = $(e).attr('name')
    
    @model.set(name, value)
    @model.save()
    
  render: =>
  
    $(@el).html(@template(@model.toJSON() ))
    
    @header = new Jetdeck.Views.Airframes.ShowHeader(model: @model)
    @$("#airframe_show_header").html(@header.render().el)
    
    @spec = new Jetdeck.Views.Airframes.ShowSpec(model: @model)
    @$("#airframe_spec_details").html(@spec.render().el)
    
    @send = new Jetdeck.Views.Airframes.ShowSend(model: @model)
    @$("#airframe_send").html(@send.render().el)

    @leads = new Jetdeck.Views.Airframes.ShowLeads(model: @model)
    if @model.leads.length > 0
      @$("#airframe_leads").html(@leads.render().el)

    @$(".number").each(->
        if $(this).val() != null
          intPrice = parseInt($(this).val().replace(/[^0-9]/g,""), 10)
          $(this).val(intPrice.formatMoney(0, ".", ","))
    )  
    
    @$(".money").each(->
        if $(this).val() != null
          intPrice = parseInt($(this).val().replace(/[^0-9]/g,""), 10)
          $(this).val("$" + intPrice.formatMoney(0, ".", ","))
    )        
    
    return this
    
