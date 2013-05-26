Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.ShowView extends Backbone.View
  template: JST["templates/airframes/show"]

  events:
    "click .manage_images"      : "manageImages"

  manageImages: () ->
    if $("#uploader").is(":visible")
      $("#uploader").hide()
    else
      $("#uploader").show()

  render: =>

    lastSpecTab = null
    if $("#airframe_spec_details .tab-pane:visible").attr("id")
      lastSpecTab = $("#airframe_spec_details .tab-pane:visible").attr("id")
      
    $(@el).html(@template(@model.toJSON() ))
    
    @header = new Jetdeck.Views.Airframes.ShowHeader(model: @model)
    @$("#airframe_show_header").html(@header.render().el)
    
    #@spec = new Jetdeck.Views.Airframes.ShowSpec(model: @model)
    #@$("#airframe_spec_details").html(@spec.render().el)
    #@$("a[href='#"+lastSpecTab+"']").tab('show') if lastSpecTab
    
    @actions = new Jetdeck.Views.Actions.ShowActions(model: @model)
    @$("#airframe_actions").html(@actions.render().el)
    
    @send = new Jetdeck.Views.Airframes.ShowSend(model: @model)

    @leads = new Jetdeck.Views.Airframes.ShowLeads(model: @model)
    if @model.leads.length > 0
      @$("#airframe_leads").html(@leads.render().el)
      @$("#airframe_send").html(@send.render().el)
    else
      @$("#airframe_send").html("")
      @$("#airframe_leads").html(@send.render().el)
    
    @delete = new Jetdeck.Views.Airframes.ShowDelete(model: @model)
    @$("#airframe_delete").html(@delete.render().el)
    
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
    
