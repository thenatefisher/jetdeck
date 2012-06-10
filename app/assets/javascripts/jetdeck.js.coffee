#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Jetdeck =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

$(->

    $(".new-spec").click( ->
        view = new Jetdeck.Views.Airframes.NewView()
        modal(view.render().el)
    )

    $(".new-contact").click( ->
        view = new Jetdeck.Views.Contacts.NewView()
        modal(view.render().el)
    )

)
