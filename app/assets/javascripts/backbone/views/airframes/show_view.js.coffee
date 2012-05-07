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
  template: JST["backbone/templates/airframes/partials/_header"]

  render: ->
    templateParams = $.extend(@model.toJSON() )
    $(@el).html(@template(@model.toJSON() ))
    return this    
    
class Jetdeck.Views.Airframes.ShowSpecView extends Backbone.View
  template: JST["backbone/templates/airframes/partials/_specDetails"]

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

class Jetdeck.Views.Airframes.AddEquipmentModalItem extends Backbone.View
  template: JST["backbone/templates/equipment/modalItem"]
  
  render : ->
    $(@el).html(@template(@model.toJSON() ))
    return this

class Jetdeck.Views.Airframes.AddEquipmentModal extends Backbone.View
  template: JST["backbone/templates/equipment/modal"]
  
  render : ->
    eCollection = new Jetdeck.Collections.EquipmentCollection()
    eCollection.fetch(
        success: (equipment) =>

            $(@el).html(@template() )
            
            equipment.each((item) =>
                view = new Jetdeck.Views.Airframes.AddEquipmentModalItem(model: item)
                switch item.get("type")
                  when "avionics"
                    @$("optgroup[label='Avionics']").append(view.render().el)
                  when "interiors"
                    @$("optgroup[label='Interiors']").append(view.render().el)
                  when "exteriors"
                    @$("optgroup[label='Exteriors']").append(view.render().el)
                  when "equipment"
                    @$("optgroup[label='Equipment']").append(view.render().el)
                  when "modifications"
                    @$("optgroup[label='Modifications']").append(view.render().el)                    
            )
            
            @$('#equipment-form').multiSelect({
              selectableHeader : '<input type="text" class="input-large" id="equipment-search" autocomplete = "off" />',
              selectedHeader : '<h4 style="background: #eee; margin-bottom: 5px; padding: 7px 10px;">Selected Equipment</h4>',
              afterSelect : @addEquipment
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
    
  addEquipment : (e) =>
    k = new Backbone.Collection()
    k.reset @model.get('avionics')
    avionics = []
    k.models.forEach((i) -> avionics.push({id: i.id}))
    avionics.push({id: e})

    @model.set({avionics: avionics})
    @model.save(null,
        success: =>
            #@render()
    )
      
  modal : =>
    modal(@render().el)
    return this
  
class Jetdeck.Views.Airframes.ShowAvionicsView extends Backbone.View
  template: JST["backbone/templates/equipment/spec"]

  events: 
    "click .removeEquipment" : "destroy"
    "click .addEquipment" : "add"
    
  add: () ->
    newAvionic = new Jetdeck.Views.Airframes.AddEquipmentModal(model: @model)
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
  template: JST["backbone/templates/airframes/partials/_send"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this            
