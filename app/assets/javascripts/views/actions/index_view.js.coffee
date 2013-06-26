Jetdeck.Views.Actions ||= {}

class Jetdeck.Views.Actions.IndexView extends Backbone.View
  template: JST["templates/actions/index"]

  initialize: ->
    @options.todos.bind('reset', @addAll)
    
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
    @options.todos.orderBy(sort)
    @options.todos.direction(direction)
    @options.todos.sort()  
    
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
    @options.todos.turnTo(1)
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    @$('.page[rel=1]').parent('li').addClass('active')
    
  page : (event) ->
    e = event.target || event.currentTarget
    n = $(e).attr('rel')
    @options.todos.turnTo(n)
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    $(e).parent('li').addClass('active')
    
  next : ->
    @options.todos.next()
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    p = @options.todos.currentPage()
    @$('.page[rel='+p+']').parent('li').addClass('active')    

  prev : ->
    @options.todos.prev()
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    p = @options.todos.currentPage()
    @$('.page[rel='+p+']').parent('li').addClass('active')    

  addAll: =>
    @clear()
    @options.todos.eachOnPage(@addOne)

  clear : ->
    @$("#actions").html('')
    
  addOne: (action) => 
    if action && !action.get("due_today")
        view = new Jetdeck.Views.Actions.ActionView({model : action})
        @$("#actions").append(view.render().el)

  render: =>  
    params =
        count : @options.todos.length
        pages : @options.todos.pages()
    $(@el).html(@template(params))
    
    # add all actions
    @addAll()    
    
    #today's actions stay on top
    @options.todos.eachOnPage( (action) =>
      if action && action.get("due_today")
        @$("#todays_actions").show()
        view = new Jetdeck.Views.Actions.ActionView({model : action})
        @$("#todays_actions").append(view.render().el)    
    )
    
    @$('.page[rel=1]').parent('li').addClass('active')   

    return this
