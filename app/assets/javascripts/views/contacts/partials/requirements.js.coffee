Jetdeck.Views.Contacts ||= {}

class Jetdeck.Views.Contacts.ShowRequirements extends Backbone.View
  template: JST["templates/contacts/requirements/pane"]

  events : 
    "click a.next" : "next"
    "click a.prev" : "prev"
    "click a.page" : "page"
    
  page : (event) ->
    e = event.target || event.currentTarget
    n = $(e).attr('rel')
    @model.requirements.turnTo(n)
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    $(e).parent('li').addClass('active')
    
  next : ->
    @model.requirements.next()
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    p = @model.requirements.currentPage()
    @$('.page[rel='+p+']').parent('li').addClass('active')    

  prev : ->
    @model.requirements.prev()
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    p = @model.requirements.currentPage()
    @$('.page[rel='+p+']').parent('li').addClass('active')    

  addAll: =>
    @clear()
    view = new Jetdeck.Views.Contacts.RequirementView()
    @$("tbody").append(view.render().el)   
    console.log view.render().el 
    #@model.requirements.eachOnPage(@addOne)

  clear : ->
    @$("tbody").html('')
    
  addOne: (req) => 
    if req
        view = new Jetdeck.Views.Contacts.RequirementView({model : req})
        @$("tbody").append(view.render().el)
        
  render : ->
    params =
        count : @model.requirements.length
        pages : @model.requirements.pages()
    $(@el).html("")
    if @model.requirements.length > 0
        $(@el).html(@template(params))
        @model.requirements.turnTo(1)
        @addAll()    
        @$('.page[rel=1]').parent('li').addClass('active')
    $(@el).html(@template(params))
    @addAll()
    return this

class Jetdeck.Views.Contacts.RequirementView extends Backbone.View
  template : JST["templates/contacts/requirements/item"]
  
  tagName : "tr"
      
  render : ->
    #$(@el).html(@template(@model.toJSON() ))
    $(@el).html(@template({}))
    return this       
