Jetdeck.Views.Actions ||= {}

class Jetdeck.Views.Actions.IndexView extends Backbone.View
  template: JST["templates/actions/index"]

  initialize: ->
    @options.actions.bind('reset', @addAll)
    
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
    @options.actions.orderBy(sort)
    @options.actions.direction(direction)
    @options.actions.sort()  
    
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
    @options.actions.turnTo(1)
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    @$('.page[rel=1]').parent('li').addClass('active')
    
  page : (event) ->
    e = event.target || event.currentTarget
    n = $(e).attr('rel')
    @options.actions.turnTo(n)
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    $(e).parent('li').addClass('active')
    
  next : ->
    @options.actions.next()
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    p = @options.actions.currentPage()
    @$('.page[rel='+p+']').parent('li').addClass('active')    

  prev : ->
    @options.actions.prev()
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    p = @options.actions.currentPage()
    @$('.page[rel='+p+']').parent('li').addClass('active')    

  addAll: =>
    @clear()
    @options.actions.eachOnPage(@addOne)

  clear : ->
    @$("#actions").html('')
    
  addOne: (action) => 
    if action
        view = new Jetdeck.Views.Actions.ActionView({model : action})
        @$("#actions").append(view.render().el)

  render: =>  
    params =
        count : @options.actions.length
        pages : @options.actions.pages()
    $(@el).html(@template(params))
    @addAll()    
    @$('.page[rel=1]').parent('li').addClass('active')   

    return this
