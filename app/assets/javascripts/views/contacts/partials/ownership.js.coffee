Jetdeck.Views.Contacts ||= {}

class Jetdeck.Views.Contacts.OwnershipItem extends Backbone.View
  template: JST["templates/contacts/partials/ownership_item"]
  
  events: 
    "click a.delete"        : "destroy"
    
  destroy: =>
    @model.destroy(success: => 
      mixpanel.track("Deleted Ownership Record")
      @model.trigger("deleted")
    )
    
  save: =>
    #assoc: @$(".assoc").val(),
    #description: @$(".description").val(), 
    
  initialize: ->
    $(@el).hover( 
      => @$(".buttons").show(),
      => @$(".buttons").hide()
    )
  
  render : =>
    $(@el).html(@template(@model.toJSON() ))
    #@$(".assoc").val(@model.get("assoc")) if @model.get("assoc")
    return this
  
class Jetdeck.Views.Contacts.ShowOwnership extends Backbone.View
  template: JST["templates/contacts/partials/ownership"]
    
  events:
    "click #add" : "create"
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
    @model.ownership.orderBy(sort)
    @model.ownership.direction(direction)
    @model.ownership.sort()  
    
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
    @model.ownership.turnTo(1)
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    @$('.page[rel=1]').parent('li').addClass('active')
    
  page : (event) ->
    e = event.target || event.currentTarget
    n = $(e).attr('rel')
    @model.ownership.turnTo(n)
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    $(e).parent('li').addClass('active')
    
  next : ->
    @model.ownership.next()
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    p = @model.ownership.currentPage()
    @$('.page[rel='+p+']').parent('li').addClass('active')    

  prev : ->
    @model.ownership.prev()
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    p = @model.ownership.currentPage()
    @$('.page[rel='+p+']').parent('li').addClass('active')    

  addAll: =>
    @clear()
    @model.ownership.eachOnPage(@addOne)

  clear : ->
    @$("#ownership_items").html('')
    
  addOne: (ownership) => 
    if ownership
      ownership.on("deleted", => @render() )
      item = new Jetdeck.Views.Contacts.OwnershipItem(model: ownership)
      @$("#ownership_items").append(item.render().el) 
            
  create: =>      
    ownership = new Jetdeck.Models.OwnershipModel()
    ownership.collection = @model.ownership
    ownership.save({
       contact_id: @model.get("id"),
       assoc: @$("#new-ownership-assoc").val(),
       description: @$("#new-ownership-description").val()
    }, success: (n) => 
      mixpanel.track "Created Ownership"
      @model.ownership.add(n)
      @render()
    )
        
  render : =>
    params =
        count : @model.ownership.length
        pages : @model.ownership.pages()
    $(@el).html(@template(params))  
    @model.ownership.turnTo(1)
    @addAll()    
    @$('.page[rel=1]').parent('li').addClass('active')  
    return this


