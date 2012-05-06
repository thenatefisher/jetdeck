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
    
    @avionics = new Jetdeck.Views.Airframes.ShowAvionicsView(model: @model)
    @$("#pane_avionics").html(@avionics.render().el)
            
    @$("#pane_avionics table").children('tbody').children('tr').first().children('td').css('border-top', '0px')

    @$(".equipmentTooltip").hover( 
      ->
        $(this).children('.removeEquipment').css('visibility', 'visible')
      ->
        $(this).children('.removeEquipment').css('visibility', 'hidden')
    )
    return this        


class Jetdeck.Models.EquipmentModel extends Backbone.Model
#    paramRoot: "equipment"

class Jetdeck.Collections.EquipmentCollection extends Backbone.Collection
    model: Jetdeck.Models.EquipmentModel
    url: "/equipment"

class Jetdeck.Views.Airframes.NewAvionicsView extends Backbone.View
  template: JST["backbone/templates/airframes/avionics/new"]
  
  initialize : ->
    
  render : ->
    eCollection = new Jetdeck.Collections.EquipmentCollection()
    eCollection.fetch(
        success: (c) =>
            #@model = new Backbone.Model()

            $(@el).html(@template(c.toJSON() ))
            
            @$('#equipment-form').multiSelect({
              selectableHeader : '<input type="text" class="input-large" id="equipment-search" autocomplete = "off" />',
              selectedHeader : '<h4 style="background: #eee; margin-bottom: 5px; padding: 7px 10px;">Selected Equipment</h4>'
            })

            @$('input#equipment-search').quicksearch('#ms-equipment-form .ms-selectable li')
            
            @$('#ms-equipment-form .ms-selectable').find('li.ms-elem-selectable').hide()
            
            @$('.ms-optgroup-label').click(() ->
              if ($(this).hasClass('ms-collapse'))
                $(this).nextAll('li').hide()
                $(this).removeClass('ms-collapse')
              else
                $(this).nextAll('li:not(.ms-selected)').show()
                $(this).addClass('ms-collapse')
            )
        failure: (failmsg) ->
            console.log failmsg
    )
    
    return this
    
  modal : =>
    modal(@render().el)
    return this
  
class Jetdeck.Views.Airframes.ShowAvionicsView extends Backbone.View
  template: JST["backbone/templates/airframes/avionics/spec"]

  events: 
    "click .removeEquipment" : "destroy"
    "click .addEquipment" : "add"
    
  add: () ->
    newAvionic = new Jetdeck.Views.Airframes.NewAvionicsView()
    newAvionic.modal()
    
  destroy: (event) ->
    e = event.target || event.currentTarget
    eid = $(e).data('eid')
    
    k = new Backbone.Collection()
    k.reset @model.get('avionics')
    k.remove(eid)
    avionics = []
    k.models.forEach((i) -> avionics.push({id: i.id}))

    old = @model
    @model.set({avionics: avionics})

    @model.save(null,
        success: =>
            @render()
    )
        
  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this  
        
class Jetdeck.Views.Airframes.ShowSendView extends Backbone.View
  template: JST["backbone/templates/airframes/_send"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this            
