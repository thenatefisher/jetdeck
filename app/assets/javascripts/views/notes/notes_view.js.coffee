Jetdeck.Views.Notes ||= {}

class Jetdeck.Views.Notes.NoteItem extends Backbone.View
  template: JST["templates/notes/note_item"]
  
  events: 
    "click .delete-note"        : "destroy"
    "click .edit-note"          : "edit"
    "click .cancel-note-edit"   : "cancel_update"
    "click .update-note"        : "save"
    "click .sticky-note"        : "sticky"
  
  sticky: ->  
    # bubble the event up to owner model
    @trigger("sticky")

  destroy: =>
    @model.destroy(success: => 
      mixpanel.track("Deleted Note", {type: @model.get("type")} )
      @model.trigger("deleted")
    )
    
  edit: =>  
    # cancel editing any other note
    $(".note-description").show()
    $("textarea.note").hide()
    $(".note-page-header").show()
    $(".note-edit-buttons").hide()  
    $(".disable-note-buttons").show()
      
    @$(".note-description").hide()
    @$("textarea.note").show()
    @$(".note-page-header").hide()
    @$(".note-edit-buttons").show()
    @$(".disable-note-buttons").hide()

    @$("textarea.note").addClass("large-note") if @model.get("description").length >= 120
    @$("textarea.note").removeClass("large-note") if @model.get("description").length < 120
    
  save: =>
    if !@$("textarea.note").val()
      @$(".control-group").addClass("error")
      return 
    
    @model.save({
      description: @$("textarea.note").val()
    }, success: () => 
      mixpanel.track "Updated Note", {type: @model.get("type")}
      @render()
      if @model.get("is_sticky") 
        @trigger("sticky") 
        @trigger("sticky") 
    )
    
  cancel_update: =>
    @$(".note-description").show()
    @$("textarea.note").hide()
    @$(".note-edit-buttons").hide()  
    @$(".disable-note-buttons").show()  
    @$(".note-page-header").show()
    
  initialize: ->
    $(@el).hover( 
      => @$(".note-buttons").show(),
      => @$(".note-buttons").hide()
    )
  
  render : =>
    $(@el).html(@template(@model.toJSON() ))
    
    @$(".note-description").toggle(
      =>
        @$(".elipsis").hide()
        @$(".more").fadeIn(100)
      =>
        @$(".more").fadeOut(100, => @$(".elipsis").show()) 
    )

    return this
  
class Jetdeck.Views.Notes.ShowNotes extends Backbone.View
  template: JST["templates/notes/notes"]
    
  initialize: =>
    @type = window.router.view.model.paramRoot.charAt(0).toUpperCase() + window.router.view.model.paramRoot.slice(1)   

  events:
    "click #add-note" : "create"
    "click a.next" : "next"
    "click a.prev" : "prev"
    "click a.page" : "page"
    "click .sort" : "sort"

  sort : (event) ->
    # capture the click and get the parameters
    e = event.target || event.currentTarget
    sort = $(e).data('sort')  
    direction = $(e).data('dir')  
    
    # perform the sort
    @model.notes.orderBy(sort)
    @model.notes.direction(direction)
    @model.notes.sort()  
    
    # set the sort button styles
    @$('.sort').parent("li").removeClass('active')
    @$(e).parent("li").addClass('active')
    @$(".sort_dir_icon").remove()
    if direction == "asc"
        @$(e).append("<i class='icon-chevron-down icon-white sort_dir_icon'></i>")    
    if direction == "desc"
        @$(e).append("<i class='icon-chevron-up icon-white sort_dir_icon'></i>")  
           
    # toggle sort button direction
    $(e).data('dir', 'desc') if direction == "asc"
    $(e).data('dir', 'asc') if direction == "desc"    
        
    # go back to first page  
    @model.notes.turnTo(1)
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    @$('.page[rel=1]').parent('li').addClass('active')
    
  page : (event) ->
    e = event.target || event.currentTarget
    n = $(e).attr('rel')
    @model.notes.turnTo(n)
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    $(e).parent('li').addClass('active')
    
  next : ->
    @model.notes.next()
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    p = @model.notes.currentPage()
    @$('.page[rel='+p+']').parent('li').addClass('active')    

  prev : ->
    @model.notes.prev()
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    p = @model.notes.currentPage()
    @$('.page[rel='+p+']').parent('li').addClass('active')    

  addAll: =>
    @clear()
    @model.notes.eachOnPage(@addOne)

  clear : ->
    @$("#note_items").html('')
    
  addOne: (note) => 
    if note
      note.on("change", => @model.trigger("note-changed"))
      note.on("deleted", => @model.trigger("note-changed"); @render() )
      # set is_sticky
      is_sticky = if (@model.get("sticky_id") == note.get("id")) then true else false
      note.set("is_sticky", is_sticky)
      item = new Jetdeck.Views.Notes.NoteItem(model: note)
      item.on("sticky", => @sticky(note.get('id') ))
      @$("#note_items").append(item.render().el) 
            
  create: =>
    if !@$("textarea").val()
      @$(".control-group").addClass("error")
      return 
      
    note = new Jetdeck.Models.NoteModel()
    note.collection = @model.notes
    note.save({
      description: @$("textarea").val(),
      notable_type: @type, 
      notable_id: @model.get('id')
    }, success: (n) => 
      mixpanel.track "Created Note", {type: @type}
      @model.notes.add(n)
      @render()
    )
        
  sticky: (note_id) =>
    # set owner-model sticky id
    if @model.get("sticky_id") == note_id then note_id = null
    @model.save({
      sticky_id: note_id
    }, success: (n) => 
      mixpanel.track "Updated Sticky"
      @model = n
      @model.trigger("sticky", note_id)
      @render()
    ) 
    # todo update masthead

  render : =>
    params =
        count : @model.notes.length
        pages : @model.notes.pages()
    $(@el).html(@template(params))  
    @model.notes.turnTo(1)
    @addAll()    
    @$('.page[rel=1]').parent('li').addClass('active')  

    if @model.notes.length == 0
      @$("#add-note-fields").show()
    else
      @$(".subsection").toggle(
        => @$("#add-note-fields").show(),
        => @$("#add-note-fields").hide()
      )     

    return this


