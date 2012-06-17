Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.IndexView extends Backbone.View
  template: JST["templates/airframes/index"]

  initialize: ->
    @options.airframes.bind('reset', @addAll)
    
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
    @options.airframes.orderBy(sort)
    @options.airframes.direction(direction)
    @options.airframes.sort()  
    
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
    @options.airframes.turnTo(1)
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    @$('.page[rel=1]').parent('li').addClass('active')
    
  page : (event) ->
    e = event.target || event.currentTarget
    n = $(e).attr('rel')
    @options.airframes.turnTo(n)
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    $(e).parent('li').addClass('active')
    
  next : ->
    @options.airframes.next()
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    p = @options.airframes.currentPage()
    @$('.page[rel='+p+']').parent('li').addClass('active')    

  prev : ->
    @options.airframes.prev()
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    p = @options.airframes.currentPage()
    @$('.page[rel='+p+']').parent('li').addClass('active')    

  addAll: =>
    window.m = @options.airframes
    @clear()
    @options.airframes.eachOnPage(@addOne)

  clear : ->
    @$("#airframes").html('')
    
  addOne: (airframe) => 
    if airframe
        view = new Jetdeck.Views.Airframes.AirframeView({model : airframe})
        @$("#airframes").append(view.render().el)

  render: =>  
    params =
        count : @options.airframes.length
        pages : @options.airframes.pages()
    $(@el).html(@template(params))
    @addAll()    
    @$('.page[rel=1]').parent('li').addClass('active')   
    if @options.airframes.length == 0
        $('.new-spec').popover(
            title: "<i class='icon-exclamation-sign' style='margin-top: 4px;'></i> Start Here",
            content: "Create a new aircraft spec to share with customers, new leads or brokers.",
            placement: "bottom"
        )
        @helpBubble = setTimeout("$('.new-spec').popover('show')", 500)
    return this
