Jetdeck.Views.Contacts ||= {}

class Jetdeck.Views.Contacts.ShowSpecs extends Backbone.View
  template: JST["templates/contacts/partials/specs"]

  events : 
    "click a.next" : "next"
    "click a.prev" : "prev"
    "click a.page" : "page"
    "click .sort"  : "sort"
  
  sort : (event) ->
    # capture the click and get the parameters
    e = event.target || event.currentTarget
    sort = $(e).data('sort')  
    direction = $(e).data('dir')  
    
    # perform the sort
    @model.specs.orderBy(sort)
    @model.specs.direction(direction)
    @model.specs.sort()  
    
    # set the sort button styles
    @$(".sort_dir_icon").remove()
    if direction == "asc"
        @$(e).append("<i class='icon-chevron-down sort_dir_icon'></i>")    
    if direction == "desc"
        @$(e).append("<i class='icon-chevron-up sort_dir_icon'></i>")  
           
    # toggle sort button direction
    $(e).data('dir', 'desc') if direction == "asc"
    $(e).data('dir', 'asc') if direction == "desc"    
        
    # go back to first page  
    @model.specs.turnTo(1)
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    @$('.page[rel=1]').parent('li').addClass('active')
    
  page : (event) ->
    e = event.target || event.currentTarget
    n = $(e).attr('rel')
    @model.specs.turnTo(n)
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    $(e).parent('li').addClass('active')
    
  next : ->
    @model.specs.next()
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    p = @model.specs.currentPage()
    @$('.page[rel='+p+']').parent('li').addClass('active')    

  prev : ->
    @model.specs.prev()
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    p = @model.specs.currentPage()
    @$('.page[rel='+p+']').parent('li').addClass('active')    

  addAll: =>
    @clear()
    @model.specs.eachOnPage(@addOne)

  clear : ->
    @$("tbody").html('')
    
  addOne: (spec) => 
    if spec
        view = new Jetdeck.Views.Specs.SpecView({model : spec})
        @$("tbody").append(view.render().el)
        
  render : ->
    params =
        count : @model.specs.length
        pages : @model.specs.pages()
    $(@el).html("")
    if @model.specs.length > 0
        $(@el).html(@template(params))
        @model.specs.turnTo(1)
        @addAll()    
        @$('.page[rel=1]').parent('li').addClass('active')
    
    return this

