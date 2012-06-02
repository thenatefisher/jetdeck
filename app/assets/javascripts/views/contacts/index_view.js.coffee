Jetdeck.Views.Contacts ||= {}

class Jetdeck.Views.Contacts.IndexView extends Backbone.View
  template: JST["templates/contacts/index"]

  initialize: ->
    @options.contacts.bind('reset', @addAll)
    
  events : 
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
    @options.contacts.orderBy(sort)
    @options.contacts.direction(direction)
    @options.contacts.sort()  
    
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
    @options.contacts.turnTo(1)
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    @$('.page[rel=1]').parent('li').addClass('active')
    
  page : (event) ->
    e = event.target || event.currentTarget
    n = $(e).attr('rel')
    @options.contacts.turnTo(n)
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    $(e).parent('li').addClass('active')
    
  next : ->
    @options.contacts.next()
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    p = @options.contacts.currentPage()
    @$('.page[rel='+p+']').parent('li').addClass('active')    

  prev : ->
    @options.contacts.prev()
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    p = @options.contacts.currentPage()
    @$('.page[rel='+p+']').parent('li').addClass('active')    

  addAll: =>
    window.m = @options.contacts
    @clear()
    @options.contacts.eachOnPage(@addOne)

  clear : ->
    @$("#contacts tbody").html('')
    
  addOne: (contact) => 
    if contact
        view = new Jetdeck.Views.Contacts.ContactView({model : contact})
        @$("#contacts tbody").append(view.render().el)

  render: =>  
    params =
        count : @options.contacts.length
        pages : @options.contacts.pages()
    $(@el).html(@template(params))
    @addAll()    
    @$('.page[rel=1]').parent('li').addClass('active')   
    return this
