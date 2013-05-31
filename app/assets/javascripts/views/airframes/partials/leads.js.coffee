Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.ShowLeads extends Backbone.View
  template: JST["templates/airframes/partials/leads"]

  initialize: () ->
    @on('add', @addAll, @model.leads)

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
    @model.leads.orderBy(sort)
    @model.leads.direction(direction)
    @model.leads.sort()  
    
    # set the sort button styles
    #@$('.sort').parent("li").removeClass('active')
    #@$(e).parent("li").addClass('active')
    @$(".sort_dir_icon").remove()
    if direction == "asc"
        @$(e).append("<i class='icon-chevron-down sort_dir_icon'></i>")    
    if direction == "desc"
        @$(e).append("<i class='icon-chevron-up sort_dir_icon'></i>")  
           
    # toggle sort button direction
    $(e).data('dir', 'desc') if direction == "asc"
    $(e).data('dir', 'asc') if direction == "desc"    
        
    # go back to first page  
    @model.leads.turnTo(1)
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    @$('.page[rel=1]').parent('li').addClass('active')
    
  page : (event) ->
    e = event.target || event.currentTarget
    n = $(e).attr('rel')
    @model.leads.turnTo(n)
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    $(e).parent('li').addClass('active')
    
  next : ->
    @model.leads.next()
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    p = @model.leads.currentPage()
    @$('.page[rel='+p+']').parent('li').addClass('active')    

  prev : ->
    @model.leads.prev()
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    p = @model.leads.currentPage()
    @$('.page[rel='+p+']').parent('li').addClass('active')    

  addAll: =>
    @clear()
    @model.leads.eachOnPage(@addOne)

  clear : ->
    @$("tbody").html('')
    
  addOne: (lead) => 
    if lead
        view = new Jetdeck.Views.Leads.LeadView({model : lead})
        @$("tbody").append(view.render().el)
        
  render : =>
    $(@el).html(JST["templates/airframes/partials/leads_temp"])
    # remove top border on first table item in spec panes
    @$("table").children('tbody').children('tr').first().children('td').css('border-top', '0px')
    #params =
    #    count : @model.leads.length
    #    pages : @model.leads.pages()
    #$(@el).html("")
    #if @model.leads.length > 0
    #    $(@el).html(@template(params))
    #    @model.leads.turnTo(1)
    #    @addAll()    
    #    @$('.page[rel=1]').parent('li').addClass('active')
    #
    return this

