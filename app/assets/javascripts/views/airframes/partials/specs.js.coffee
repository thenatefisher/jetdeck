Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.ShowSpecs extends Backbone.View
  template: JST["templates/airframes/partials/specs"]

  render: ->
    $(@el).html(@template())

    groups = []
    @model.specs.each((spec) =>

        if (groups.indexOf(spec.get('file_name')) < 0)

            spec_group = @model.specs.where(file_name: spec.get('file_name'))
            if (spec_group.length > 1)

                # skip over this group after rendering here
                groups.push(spec.get('file_name'))

                #setup a collection to manupulate these specs
                collection = new Jetdeck.Collections.SpecFilesCollection()
                collection.reset spec_group

                # render the header
                view = new Jetdeck.Views.Airframes.SpecGroupHeader({model : spec})
                @$("tbody").append(view.render().el) if view

                # render each nested spec
                collection.each((spec_group_item) =>
                    spec_group_item_view = new Jetdeck.Views.Airframes.SpecGroupItem({model : spec_group_item}) 
                    @$("tbody").append(spec_group_item_view.render().el) if view
                )

            else
                view = new Jetdeck.Views.Airframes.Spec({model : spec})
                @$("tbody").append(view.render().el) if view

    
    )

    # remove top border on first table item 
    @$("table").children('tbody').children('tr').first().children('td').css('border-top', '0px')

    return this

class Jetdeck.Views.Airframes.SpecGroupHeader extends Backbone.View
  template: JST["templates/airframes/partials/spec_group"]

  tagName: "tr"

  initialize: =>
    $(@el).on("click", @toggle)

  toggle: =>
    if $(@el).find('.open').first().is(':hidden')
        $(@el).find('.open').show()
        $(@el).find('.closed').hide()
    else
        $(@el).find('.open').hide()
        $(@el).find('.closed').show()

    window.e = $(@el)

    tr = $(@el).next()
    loop
        break if tr.size() == 0 || !tr.hasClass('nested_item')
        if tr.is(':hidden')
            tr.show() 
        else
            tr.hide()
        tr = tr.next()

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    $(@el).addClass("group_header")

    return this

class Jetdeck.Views.Airframes.SpecGroupItem extends Backbone.View
  template: JST["templates/airframes/partials/spec_group_item"]

  tagName: "tr"

  render: ->
    updated_string = convert_time(@model.get('created_at'))
    @model.set('updated', updated_string)    

    $(@el).html(@template(@model.toJSON() ))
    $(@el).addClass("nested_item")

    return this


class Jetdeck.Views.Airframes.Spec extends Backbone.View
  template: JST["templates/airframes/partials/spec_item"]

  tagName: "tr"

  render: ->
    updated_string = convert_time(@model.get('created_at'))
    @model.set('updated', updated_string)  

    $(@el).html(@template(@model.toJSON() ))

    return this

class Jetdeck.Views.Airframes.NewSpec extends Backbone.View
  template: JST["templates/airframes/partials/spec_new"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))

    return this
