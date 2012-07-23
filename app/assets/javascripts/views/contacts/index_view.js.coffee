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
    if @options.contacts.length == 0
        $('.new-contact').popover(
            title: "<i class='icon-exclamation-sign' style='margin-top: 4px;'></i> Start Here",
            content: "Create a new broker, lead or other aircraft contact to associate with specs in your deck.",
            placement: "bottom"
        )
        @helpBubble = setTimeout("$('.new-contact').popover('show')", 500)    
    return this
