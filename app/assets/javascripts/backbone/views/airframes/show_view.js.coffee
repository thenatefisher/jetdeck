Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.ShowView extends Backbone.View
  template: JST["backbone/templates/airframes/show"]
    
  events:
    "change .inline_edit": "edit"
  
  edit: (e) ->
    if $(e.target).hasClass('number')
      value = parseInt($(e.target).val().replace(/[^0-9]/g,""))
      $(e.target).val(value.formatMoney(0, ".", ","))
    else if $(e.target).hasClass('money')
      value = parseInt($(e.target).val().replace(/[^0-9]/g,""))
      $(e.target).val("$"+value.formatMoney(0, ".", ","))    
    else
      value = $(e.target).val()
      
    name = $(e.target).attr('name')
    editInline(@model, name, value)   
  
  render: =>
    @model.fetch(
      success: () =>
        $(@el).html(@template(@model.toJSON() ))
        
        @header = new Jetdeck.Views.Airframes.ShowHeaderView(model: @model)
        @$("#airframe_show_header").html(@header.render().el)     
        
        @spec = new Jetdeck.Views.Airframes.ShowSpecView(model: @model)
        @$("#airframe_spec_details").html(@spec.render().el)           
        
        @send = new Jetdeck.Views.Airframes.ShowSendView(model: @model)
        @$("#airframe_send").html(@send.render().el)

        @$(".money").each(->
            if $(this).val() != null
              intPrice = parseInt($(this).val().replace(/[^0-9]/g,""))
              $(this).val("$"+intPrice.formatMoney(0, ".", ","))
        )
        
        @$(".number").each(->
            if $(this).val() != null
              intPrice = parseInt($(this).val().replace(/[^0-9]/g,""))
              $(this).val(intPrice.formatMoney(0, ".", ","))
        )
               
      failure: () ->
    )
    
    return this
  
class Jetdeck.Views.Airframes.ShowHeaderView extends Backbone.View
  template: JST["backbone/templates/airframes/_header"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this    
    
class Jetdeck.Views.Airframes.ShowSpecView extends Backbone.View
  template: JST["backbone/templates/airframes/_specDetails"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this        
    
class Jetdeck.Views.Airframes.ShowSendView extends Backbone.View
  template: JST["backbone/templates/airframes/_send"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this            
