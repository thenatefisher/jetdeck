Jetdeck.Views.Contacts ||= {}
Jetdeck.Views.Contacts.Header ||= {}

class Jetdeck.Views.Contacts.Header.Editable extends Backbone.View
  template: JST["templates/contacts/header/editable"]

  initialize: () ->
    @model.on('change', @renderHeadline)

  renderHeadline: () =>
    #$("#headline").html(@model.get("year"))
    return this

  initializeEditableFields: =>
    # setup editable fields
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

  render: =>
    # render header container
    $(@el).html(@template(@model.toJSON() ))

    # wait for container content to be loaded in DOM
    $(() => 
      # init editable fields
      @initializeEditableFields()
      # render headline
      @renderHeadline()
    )

    return this

class Jetdeck.Views.Contacts.Header.StickyNote extends Backbone.View
  template: JST["templates/contacts/header/stickyNote"]

  events:
    "click .close"         : "close"

  close: =>
    @trigger('unstick')

  render: =>
    $(@el).html(@template(@model.toJSON() )) 
    return this

class Jetdeck.Views.Contacts.Header extends Backbone.View
  template: JST["templates/contacts/header/header"]
  
  initialize: =>
    @model.on("sticky", (note_id) => @renderStickyNote(note_id))

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

    @renderStickyNote()

    @$('#contact_details').hover(
      =>  @$('.more_details').fadeIn(400),
      =>  if (!$(".editable-container").is(":visible")) 
        @$('.more_details').fadeOut(100)
    )

    @$("#big_note").toggle(
      =>
        @$(".elipsis").hide()
        @$(".more").fadeIn(100)
      =>
        @$(".more").fadeOut(100, => @$(".elipsis").show()) 
    )

    return this
