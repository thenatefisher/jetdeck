Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.ShowSpec extends Backbone.View
  template: JST["templates/airframes/partials/specs"]

  render: ->
    # load the tabs container
    $(@el).html(@template(@model.toJSON() ))

    # remove top border on first table item in spec panes
    @$("table").children('tbody').children('tr').first().children('td').css('border-top', '0px')

    return this

