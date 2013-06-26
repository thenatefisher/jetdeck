Jetdeck.Views.Contacts ||= {}

class Jetdeck.Views.Contacts.ShowView extends Backbone.View
  template: JST["templates/contacts/show"]

  events:
    "keydown .inline-edit"      : "edit"
  
  initialize: =>
    $("#cancel-changes").on("click", @cancel)
    $("#save-changes").on("click", @save)
    
  cancel: (e) =>
    @model.fetch(success: =>
      @model.updateChildren()
      $("#changes").children().fadeOut()
      $("#changes").slideUp(->
        window.router.view.render()  
      )
    )
    
  edit: (event) ->
    if event
      element = event.target || event.currentTarget 
      $(element).addClass("changed")
    $("#changes").children().fadeIn()
    $("#changes").slideDown()
  
  save: (e) =>
    $("#save-changes").prop('disabled', true)
    $(".error").html("")
    self = this
    
    # remove any blank pending custom detail items
    @model.custom_details.each (i) =>
      if i.get("pending") && ((i.get("value") == null || i.get("value") == "") && (i.get("name") == null || i.get("name") == ""))
        @model.custom_details.remove(i)   
    
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
          mixpanel.track("Updated Contact")
        )

      error: (model, error) =>
        @cancel()
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

    @notes = new Jetdeck.Views.Notes.ShowNotes(model: @model)
    @$("#contact_notes").html(@notes.render().el)    
      
    @model.on("unstick", => 
      @model.set("sticky_id", null)
      @notes.render() 
    )

    @todos = new Jetdeck.Views.Actions.ShowActions(model: @model)
    @$("#contact_actions").html(@todos.render().el)  
    
    @delete = new Jetdeck.Views.Delete.ShowDelete(model: @model)
    @$("#contact_delete").html(@delete.render().el)
    
    return this

class Jetdeck.Views.Contacts.ShowMastheadView extends Backbone.View
  template: JST["templates/notes/partials/masthead"]

  events:
    "click .close"         : "close"

  close: =>
    @trigger('unstick')

  render: =>
    $(@el).html(@template(@model.toJSON() )) 
    return this

class Jetdeck.Views.Contacts.ShowHeaderView extends Backbone.View
  template: JST["templates/contacts/partials/header"]
  
  initialize: =>
    @model.on("sticky", (note_id) => @renderStickyNote(note_id))

  events:
    "click #detail-add"         : "add"

  add : =>
    detail = new Jetdeck.Models.CustomDetailModel()
    detail.set("pending", "true")
    @model.custom_details.add(detail)
    @render()
    window.router.view.edit()

  renderCustomDetails: =>
    if @model.custom_details.length > 0
      @$("#custom-details").append("<div>&nbsp;</div>")
    @model.custom_details.each (i) =>
      item_view = new Jetdeck.Views.Contacts.CustomDetailItem(model: i)
      @$("#custom-details").append(item_view.render().el)

  renderStickyNote: =>
    sticky_note = @model.notes.where({id: @model.get('sticky_id')})[0]
    if sticky_note
      sticky_view = new Jetdeck.Views.Contacts.ShowMastheadView(model: sticky_note)
      sticky_view.on("unstick", => @model.trigger("unstick"))
      @$("#big_note").html(sticky_view.render().el)
    else
      @$("#big_note").html("")

  render: =>
    $(@el).html(@template(@model.toJSON() )) 
    #@renderCustomDetails()

    @renderStickyNote()

    @$('#name').editable({
      title: 'Contact Name',
      value: {
        first: @model.get('first'), 
        last: @model.get('last')
      },
      placement: 'bottom',
      send: 'never',
      url: (obj) => 
        @model.set('first', obj.value.first); 
        @model.set('last', obj.value.last); 
        @model.save()
    })

    @$('#company').editable({url: (obj) => @model.set(obj.name, obj.value); @model.save()})
    @$('#phone').editable({url: (obj) => @model.set(obj.name, obj.value); @model.save()})
    @$('#email').editable({url: (obj) => @model.set(obj.name, obj.value); @model.save()})

    @$('#Owner_3').editable()
    @$('#Owner_2').editable()
    @$('#Owner_1').editable()
    @$('#Pilot').editable({
      url: '/post',
      title: 'Pilot Of',
      value: {
        label: "Pilot", 
        value: "Dassault 7X"
      }             
    })          
    @$('#Mobile').editable()
    @$('#Address').editable()
    @$('#Birthday').editable()

    @$('#add_detail_item').editable({
      url: '/post',
      title: 'New Contact Detail',
      value: {
        label: "", 
        value: ""
      }                  
    })

    @$('#add_aircraft_item').editable({
      url: '/post',
      title: 'Add Aircraft to Contact',
      value: {
        label: "", 
        value: ""
      }             
    })

    @$('#contact_details').hover(
      =>  @$('.more_details').fadeIn(400),
      =>  if (!$(".editable-container").is(":visible")) 
        @$('.more_details').fadeOut(100)
    )

    @$(".remove_detail").parent("div").hover(
      => @$(this).find(".remove_detail").show(),
      => @$(this).find(".remove_detail").hide()
    )

    @$("#big_note").toggle(
      =>
        @$(".elipsis").hide()
        @$(".more").fadeIn(100)
      =>
        @$(".more").fadeOut(100, => @$(".elipsis").show()) 
    )

    return this
