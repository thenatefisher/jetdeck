
class Jetdeck.Views.Airframes.AddEquipmentModalItem extends Backbone.View
  template: JST["templates/equipment/modalItem"]

  render : ->
    $(@el).html(@template(@model.toJSON() ))
    return this

class Jetdeck.Views.Airframes.AddEquipmentModal extends Backbone.View
  template: JST["templates/equipment/modal"]

  render : =>
    eCollection = new Jetdeck.Collections.EquipmentCollection()
    eCollection.fetch(
        success: (equipment) =>

            $(@el).html(@template({type: @options.type}) )

            if !(@options.type)
                equipment.each((item) =>
                    view = new Jetdeck.Views.Airframes.AddEquipmentModalItem(model: item)
                    switch item.get("type")
                      when "avionics"
                        @$("optgroup[label='Avionics']").append(view.render().el)
                      when "cosmetics"
                        @$("optgroup[label='Cosmetics']").append(view.render().el)
                      when "equipment"
                        @$("optgroup[label='Equipment']").append(view.render().el)
                      when "modifications"
                        @$("optgroup[label='Modifications']").append(view.render().el)
                )
            else
                equipment.each((item) =>
                    if item.get("type") == "engines"
                        view = new Jetdeck.Views.Airframes.AddEquipmentModalItem(model: item)
                        @$("#avail-parts").append(view.render().el)

                )

            @$('#equipment-form').multiSelect({
              selectableHeader : '<input type="text" class="input-large" id="equipment-search" autocomplete = "off" />',
              selectedHeader : '<h4 style="background: #eee; margin-bottom: 5px; padding: 7px 10px;">Selected Equipment</h4>',
              afterSelect : @addEquipment,
              afterDeselect : @removeEquipment
            })

            @$('input#equipment-search').quicksearch('#ms-equipment-form .ms-selectable li')

            if !(@options.type)
                @$('#ms-equipment-form .ms-selectable').find('li.ms-elem-selectable').hide()
                @$('.ms-optgroup-label').click(() ->
                  if ($(this).hasClass('ms-collapse'))
                    $(this).nextAll('li').hide()
                    $(this).removeClass('ms-collapse')
                  else
                    $(this).nextAll('li:not(.ms-selected)').show()
                    $(this).addClass('ms-collapse')
                )

            @model.equipment.forEach((elem) => @$("#equipment-form").multiSelect('select', elem.id))

        failure: (failmsg) ->
            console.log failmsg
    )

    return this

  removeEquipment : (e) =>
    @model.equipment.remove(e)
    @model.save(null,
        success: =>
            @model.fetch( success: => @options.parent.render())
    )

  addEquipment : (e) =>
    @model.equipment.push({id: e})
    @model.save(null,
        success: =>
            @model.fetch( success: => @options.parent.render())
    )

  modal : =>
    modal(@render().el)
    return this
