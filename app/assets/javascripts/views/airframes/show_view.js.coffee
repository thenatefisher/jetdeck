Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.ShowView extends Backbone.View
  template: JST["templates/airframes/show"]

  render: =>
      
    $(@el).html(@template(@model.toJSON() ))
    
    @header = new Jetdeck.Views.Airframes.ShowHeader(model: @model)
    @$("#airframe_show_header").html(@header.render().el)
    
    @todos = new Jetdeck.Views.Actions.ShowActions(model: @model)
    @$("#airframe_actions").html(@todos.render().el)
    
    @specs = new Jetdeck.Views.Airframes.ShowSpecs(model: @model)
    @$("#airframe_specs").html(@specs.render().el)

    @delete = new Jetdeck.Views.Delete.ShowDelete(model: @model)
    @$("#airframe_delete").html(@delete.render().el)
    
    @$(".number").each(->
        if $(this).val() != null
          intPrice = parseInt($(this).val().replace(/[^0-9]/g,""), 10)
          $(this).val(intPrice.formatMoney(0, ".", ","))
    )  
    
    @$(".money").each(->
        if $(this).val() != null
          intPrice = parseInt($(this).val().replace(/[^0-9]/g,""), 10)
          $(this).val("$" + intPrice.formatMoney(0, ".", ","))
    )        
    
    return this
    
