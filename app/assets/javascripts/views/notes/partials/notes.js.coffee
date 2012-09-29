Jetdeck.Views.Notes ||= {}

class Jetdeck.Views.Notes.NoteItem extends Backbone.View
  template: JST["templates/notes/partials/note_item"]
  
  events: 
    "click .delete-note"        : "destroy"
    "click .edit-note"          : "edit"
    "click .cancel-note-edit"   : "cancel_update"
    "click .update-note"        : "save"
    
  destroy: =>
    @model.destroy(success: => 
      mixpanel.track("Deleted Note", {type: @model.get("type")} )
      @model.trigger("deleted")
    )
    
  edit: =>  
    # cancel editing any other note
    $(".note-description").show()
    $("textarea.note").hide()
    $(".note-edit-buttons").hide()  
    $(".disable-note-buttons").show()
      
    @$(".note-description").hide()
    @$("textarea.note").show()
    @$(".note-edit-buttons").show()
    @$(".disable-note-buttons").hide()
    
  save: =>
    console.log "hey"
    if !@$("textarea.note").val()
      @$(".control-group").addClass("error")
      return 
    
    @model.save({
      description: @$("textarea.note").val()
    }, success: (n) => 
      mixpanel.track "Updated Note", {type: @model.get("type")}
      @model = n
      @render()
    )
    
  cancel_update: =>
    @$(".note-description").show()
    @$("textarea.note").hide()
    @$(".note-edit-buttons").hide()  
    @$(".disable-note-buttons").show()  
    
  initialize: ->
    $(@el).hover( 
      => @$(".note-buttons").show(),
      => @$(".note-buttons").hide()
    )
  
  render : =>
    $(@el).html(@template(@model.toJSON() ))
    return this
  
class Jetdeck.Views.Notes.ShowNotes extends Backbone.View
  template: JST["templates/notes/partials/notes"]
    
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
      note.on("deleted", => @render() )
      item = new Jetdeck.Views.Notes.NoteItem(model: note)
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
        
  render : =>
    params =
        count : @model.notes.length
        pages : @model.notes.pages()
    $(@el).html(@template(params))  
    @model.notes.turnTo(1)
    @addAll()    
    @$('.page[rel=1]').parent('li').addClass('active')  
    return this


