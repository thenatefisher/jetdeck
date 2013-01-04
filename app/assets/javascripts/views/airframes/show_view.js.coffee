Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.ShowView extends Backbone.View
  template: JST["templates/airframes/show"]

  events:
    "keydown .inline-edit"      : "edit"
    "click .manage_images"      : "manageImages"
  
  initialize: =>
    $("#cancel-changes").on("click", @cancel)
    $("#save-changes").on("click", @save)
    
  cancel: =>
    @model.fetch(success: =>
      @model.updateChildren()
      $("#changes").children().fadeOut()
      $("#changes").slideUp(->
        window.router.view.render()  
      )
    )

  manageImages: () ->
    if $("#uploader").is(":visible")
      $("#uploader").hide()
      $("a.manage_images_link").html("Manage Images")
    else
      $("#uploader").show()
      $("a.manage_images_link").html("Hide Images")
      
  edit: (event) ->
    if event
        element = event.target || event.currentTarget 
        $(element).addClass("changed")
    $("#changes").children().fadeIn()
    $("#changes").slideDown()
  
  save: (e) =>
    $("#save-changes").prop('disabled', true)
    self = this
    imagesUploaded = false
            
    $(".inline-edit").each( ->
      
      # strip leading/trailing space
      this.value = this.value.replace(/(^\s*)|(\s*$)/gi,"")
      this.value = this.value.replace(/\n /,"\n")
      
      # format for money and thousands sep numbers
      if $(this).hasClass('number')
        this.value = parseInt(this.value.replace(/[^0-9]/g,""), 10)
      else if $(this).hasClass('money')
        this.value = parseInt(this.value.replace(/[^0-9]/g,""), 10)

      self.model.set(this.name, this.value)  
      
    )
    
    @model.save(null,
      success: (response) =>
        $("#changes").children().fadeOut()
        $("#changes").slideUp( =>
          @model.updateChildren()
          window.router.view.render()
          alertSuccess("<i class='icon-ok icon-large'></i> Changes Saved!") 
          @manageImages() if imagesUploaded
          mixpanel.track("Airframe Updated")
        )

      error: =>
        @cancel()
        alertFailure("<i class='icon-warning-sign icon-large'></i> Error Saving Changes")      
    )
    
    $("#save-changes").prop('disabled', false)

  render: =>
    lastSpecTab = null
    if $("#airframe_spec_details .tab-pane:visible").attr("id")
      lastSpecTab = $("#airframe_spec_details .tab-pane:visible").attr("id")
      
    $(@el).html(@template(@model.toJSON() ))
    
    @header = new Jetdeck.Views.Airframes.ShowHeader(model: @model)
    @$("#airframe_show_header").html(@header.render().el)
    
    @spec = new Jetdeck.Views.Airframes.ShowSpec(model: @model)
    @$("#airframe_spec_details").html(@spec.render().el)
    @$("a[href='#"+lastSpecTab+"']").tab('show') if lastSpecTab
    
    @send = new Jetdeck.Views.Airframes.ShowSend(model: @model)
    @$("#airframe_send").html(@send.render().el)
    
    @actions = new Jetdeck.Views.Actions.ShowActions(model: @model)
    @$("#airframe_actions").html(@actions.render().el)
    
    @leads = new Jetdeck.Views.Airframes.ShowLeads(model: @model)
    if @model.leads.length > 0
      @$("#airframe_leads").html(@leads.render().el)
    
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
    
