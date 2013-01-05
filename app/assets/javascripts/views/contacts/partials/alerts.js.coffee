Jetdeck.Views.Contacts ||= {}

class Jetdeck.Views.Contacts.ShowAlerts extends Backbone.View
  template: JST["templates/contacts/alerts/pane"]

  events : 
    "click a.next" : "next"
    "click a.prev" : "prev"
    "click a.page" : "page"
    
  page : (event) ->
    e = event.target || event.currentTarget
    n = $(e).attr('rel')
    @model.alerts.turnTo(n)
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    $(e).parent('li').addClass('active')
    
  next : ->
    @model.alerts.next()
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    p = @model.alerts.currentPage()
    @$('.page[rel='+p+']').parent('li').addClass('active')    

  prev : ->
    @model.alerts.prev()
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    p = @model.alerts.currentPage()
    @$('.page[rel='+p+']').parent('li').addClass('active')    

  addAll: =>
    @clear()
    view = new Jetdeck.Views.Contacts.AlertView()
    @$("tbody").append(view.render().el)   
    #@model.alerts.eachOnPage(@addOne)

  clear : ->
    @$("tbody").html('')
    
  addOne: (req) => 
    if req
        view = new Jetdeck.Views.Contacts.AlertView({model : req})
        @$("tbody").append(view.render().el)
        
  render : ->
    params =
        count : @model.alerts.length
        pages : @model.alerts.pages()
    $(@el).html("")
    if @model.alerts.length > 0
        $(@el).html(@template(params))
        @model.alerts.turnTo(1)
        @addAll()    
        @$('.page[rel=1]').parent('li').addClass('active')
    $(@el).html(@template(params))
    @addAll()
    return this

class Jetdeck.Views.Contacts.AlertView extends Backbone.View
  template : JST["templates/contacts/alerts/item"]
  
  tagName : "tr"
      
  render : ->
    #$(@el).html(@template(@model.toJSON() ))
    $(@el).html(@template({}))
    return this       
