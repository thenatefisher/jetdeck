Jetdeck.Views.Contacts ||= {}

class Jetdeck.Views.Contacts.IndexView extends Backbone.View
  template: JST["templates/contacts/index"]

  initialize: ->
    @options.contacts.bind('reset', @addAll)

  events :
    "click a.next" : "next"
    "click a.prev" : "prev"
    "click a.page" : "page"

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
    @clear()
    @options.contacts.eachOnPage(@addOne)

  clear : ->
    @$("#contacts").html('')

  addOne: (contact) =>
    if contact
        view = new Jetdeck.Views.Contacts.ContactView({model : contact})
        @$("#contacts").append(view.render().el)

  render: =>
    params =
        count : @options.contacts.length
        pages : @options.contacts.pages()
        
    $(@el).html(@template(params))
    @addAll()
    @$('.page[rel=1]').parent('li').addClass('active')
    return this
