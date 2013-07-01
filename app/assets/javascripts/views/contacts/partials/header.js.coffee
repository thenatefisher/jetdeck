Jetdeck.Views.Contacts ||= {}
Jetdeck.Views.Contacts.Header ||= {}

class Jetdeck.Views.Contacts.Header.Editable extends Backbone.View
  template: JST["templates/contacts/header/editable"]

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

  render: =>
    # render header container
    $(@el).html(@template(@model.toJSON() ))

    # wait for container content to be loaded in DOM
    $(() => @initializeEditableFields())

    return this

class Jetdeck.Views.Contacts.Header.StickyNote extends Backbone.View
  template: JST["templates/contacts/header/stickyNote"]

  events:
    "click .close" : "unstick"
    "click .alert" : "toggleExpand"

  initialize: =>
    @noteCollapsed = true

  toggleExpand: =>
    if @noteCollapsed
      @$(".elipsis").hide()
      @$(".more").fadeIn(100)
    else
      @$(".more").fadeOut(100, => @$(".elipsis").show()) 
    @noteCollapsed = !@noteCollapsed

  unstick: =>
    @model.trigger('unstick')

  render: =>
    $(@el).html(@template(@model.toJSON() )) 
    return this

class Jetdeck.Views.Contacts.Header.Show extends Backbone.View
  template: JST["templates/contacts/header/header"]

  renderStickyNote: =>
    sticky_note = @model.notes.where({id: @model.get('sticky_id')})[0]
    if sticky_note
      sticky_note.on("unstick", () => @clearStickyNote())
      sticky_view = new Jetdeck.Views.Contacts.Header.StickyNote(model: sticky_note)
      @$("#big_note").html(sticky_view.render().el)
    else
      @$("#big_note").html("")

  clearStickyNote: =>
    @model.save('sticky_id', null)
    @renderStickyNote()

  renderEditable: =>
    view = new Jetdeck.Views.Contacts.Header.Editable(model: @model)
    @$("#contact-editable").html(view.render().el)

  render: =>
    $(@el).html(@template(@model.toJSON() )) 

    $(() => 
      @renderStickyNote()
      @renderEditable()
    )

    return this
