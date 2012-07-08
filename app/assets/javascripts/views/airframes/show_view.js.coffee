Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.ShowView extends Backbone.View
  template: JST["templates/airframes/show"]

  events:
    "change .airframe_field"  : "edit"
    "click .manage_images" : "manageImages"

  manageImages: () ->
    if @$("#uploader").is(":visible")
      @$("#uploader").hide()
      @$(".manage_images a").html("Manage Images")
    else
      @$("#uploader").show()
      @$(".manage_images a").html("Hide Images")

  edit: (e) ->
    if $(e.target).hasClass('number')
      value = parseInt($(e.target).val().replace(/[^0-9]/g,""), 10)
      $(e.target).val(value.formatMoney(0, ".", ","))
    else if $(e.target).hasClass('money')
      value = parseInt($(e.target).val().replace(/[^0-9]/g,""), 10)
      $(e.target).val("$"+value.formatMoney(0, ".", ","))
    else
      value = $(e.target).val()

    name = $(e.target).attr('name')
    editInline(@model, name, value)

  initialize : =>
    @model.parentView = this

  show_leads : ->
    if @model.leads.length > 0
      @leads = new Jetdeck.Views.Airframes.ShowLeadsView(model: @model)
      @$("#airframe_leads").html(@leads.render().el)

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

        @show_leads()

        @$(".money").each(->
            if $(this).val() != null
              intPrice = parseInt($(this).val().replace(/[^0-9]/g,""), 10)
              $(this).val("$"+intPrice.formatMoney(0, ".", ","))
        )

        @$(".number").each(->
            if $(this).val() != null
              intPrice = parseInt($(this).val().replace(/[^0-9]/g,""), 10)
              $(this).val(intPrice.formatMoney(0, ".", ","))
        )

        @$('#airframe_image_upload').fileupload()

        # uploader settings:
        @$('#airframe_image_upload').fileupload('option', {
            url: '/accessories'
            process: [
                {
                    action: 'load',
                    fileTypes: /^image\/(gif|jpeg|png)$/,
                    maxFileSize: 50000000 # 5MB
                },
                {
                    action: 'resize',
                    maxWidth: 1440,
                    maxHeight: 900
                },
                {
                    action: 'save'
                }
            ]
        })

        @$('#airframe_image_upload').bind('fileuploaddrop', =>
          @$('#uploader').show()
          @$(".manage_images a").html("Hide Images")
        )

        # upload server status check for browsers with CORS support:
        if ($.support.cors)
            $.ajax({
                url: '/accessories',
                type: 'HEAD'
            }).fail( () ->
                $('<span class="alert alert-error"/>')
                    .text('Uploads Unavailable')
                    .appendTo('#airframe_image_upload');
            )

        $.getJSON("/accessories/?airframe=" + @model.get("id"),  (files) =>
            fu = @$('#airframe_image_upload').data('fileupload')
            fu._renderDownload(files)
                .appendTo(@$('#airframe_image_upload .files'))
                .removeClass("fade")
        )

      # handle failure on load of airframe data
      failure: () ->
    )

    return this

class Jetdeck.Views.Airframes.ShowHeaderView extends Backbone.View
  template: JST["templates/airframes/partials/_header"]

  events:
    "click .set-thumbnail" : "setThumbnail"

  setThumbnail: (event) ->
    e = event.target || event.currentTarget
    accessoryId = $(e).data("aid")
    $.ajax( {
        url: "/accessories/" + accessoryId, 
        data: {thumbnail: true},
        type: "PUT",
        success: => 
            @model.fetch({
                success: => 
                    @render()
                    @loadAccessories()
                    $("#uploader").show()
                    })
        }
    )

  loadAccessories: () ->
    $('#airframe_image_upload').fileupload()

    # uploader settings:
    $('#airframe_image_upload').fileupload('option', {
        url: '/accessories'
        process: [
            {
                action: 'load',
                fileTypes: /^image\/(gif|jpeg|png)$/,
                maxFileSize: 50000000 # 5MB
            },
            {
                action: 'resize',
                maxWidth: 1440,
                maxHeight: 900
            },
            {
                action: 'save'
            }
        ]
    })

    $('#airframe_image_upload').bind('fileuploaddrop', =>
      $('#uploader').show()
      $(".manage_images a").html("Hide Images")
    )

    # upload server status check for browsers with CORS support:
    if ($.support.cors)
        $.ajax({
            url: '/accessories',
            type: 'HEAD'
        }).fail( () ->
            $('<span class="alert alert-error"/>')
                .text('Uploads Unavailable')
                .appendTo('#airframe_image_upload');
        )

    $.getJSON("/accessories/?airframe=" + @model.get("id"),  (files) =>
        fu = $('#airframe_image_upload').data('fileupload')
        fu._renderDownload(files)
            .appendTo($('#airframe_image_upload .files'))
            .removeClass("fade")
    )  
    
  render: ->
    templateParams = $.extend(@model.toJSON() )
    $(@el).html(@template(@model.toJSON() ))  
    return this

class Jetdeck.Views.Airframes.ShowSpecView extends Backbone.View
  template: JST["templates/airframes/partials/_specDetails"]

  events:
    "click .addEquipment"       : "add"
    "change .inline-edit"     : "edit"

  add: () =>
    newEquipment = new Jetdeck.Views.Airframes.AddEquipmentModal(model: @model, parent: this)
    newEquipment.modal()
    
  edit: (event) ->
    e = event.target || event.currentTarget
    
    if $(e).hasClass('number')
      value = parseInt($(e).val().replace(/[^0-9]/g,""), 10)
      $(e).val(value.formatMoney(0, ".", ","))
    else
      value = $(e).val()

    name = $(e).attr('name')
    
    @model.set(name, value)
    @model.save()
    
  render: ->
    # load the tabs container
    $(@el).html(@template(@model.toJSON() ))

    # populate engines tab
    @engines = new Jetdeck.Views.Airframes.EnginePaneView(model: @model)
    @$("#pane_engines").html(@engines.render().el)

    # populate avionics tab
    @avionics = new Jetdeck.Views.Airframes.SpecPaneView(type: 'avionics', model: @model)
    @$("#pane_avionics").html(@avionics.render().el)

    # populate cosmetics tab
    @cosmetics = new Jetdeck.Views.Airframes.SpecPaneView(type: 'cosmetics', model: @model)
    @$("#pane_cosmetics").html(@cosmetics.render().el)

    # populate the equipment tab
    @equipment = new Jetdeck.Views.Airframes.SpecPaneView(type: 'equipment', model: @model)
    @$("#pane_equipment").html(@equipment.render().el)

    # remove top border on first table item in spec panes
    @$(".spec_pane table").children('tbody').children('tr').first().children('td').css('border-top', '0px')

    # trashcan icon visible on hover
    @$(".equipmentTooltip").hover(
      ->
        $(this).children('.removeEquipment').css('visibility', 'visible')
      ->
        $(this).children('.removeEquipment').css('visibility', 'hidden')
    )

    return this

# This is a pane inside the specification tab container
# and only displays engines
class Jetdeck.Views.Airframes.EnginePaneView extends Backbone.View
  template: JST["templates/equipment/engine_pane"]

  events:
    "click .remove_engine"    : "destroy"
    "change .inline-edit"     : "edit"
    "click .copy_engine"      : "copy"
    "click .add_engine"       : "add"

  edit: (event) ->
    e = event.target || event.currentTarget
    engineId = $(e).data('eid')
    
    if $(e).hasClass('number')
      value = parseInt($(e).val().replace(/[^0-9]/g,""), 10)
      $(e).val(value.formatMoney(0, ".", ","))
    else
      value = $(e).val()

    name = $(e).attr('name')
    
    @model.engines.get(engineId).set(name, value)
    @model.engines.get(engineId).save()
  
  copy: (event) ->
    e = event.target || event.currentTarget
    engineId = $(e).data('eid')
    
    newEngine = new Jetdeck.Models.EngineModel()
    newEngine.attributes = @model.engines.get(engineId).attributes
    newEngine.attributes.airframe_id = @model.id
    newEngine.attributes.id = null

    @model.engines.on("add", @render)
    @model.engines.create(newEngine.toJSON())    
    return
  
  add: () =>
    newEquipment = new Jetdeck.Views.Airframes.AddEquipmentModal(type: "engines", model: @model, parent: this)
    newEquipment.modal()
    return

  destroy: (event) ->
    e = event.target || event.currentTarget
    engineId = $(e).data('eid')
    @model.engines.get(engineId).destroy(
        success: =>
           @render()
    )
    return 
    
  render: =>
    $(@el).html(@template(engineItems: @model.engines.toJSON() ))

    @$(".number").each(->
        if $(this).val() != null
          intPrice = parseInt($(this).val().replace(/[^0-9]/g,""), 10)
          $(this).val(intPrice.formatMoney(0, ".", ","))
    )    
    
    return this

# This is a pane inside the specification tab container
# The SpecPaneView doesn't display engines
class Jetdeck.Views.Airframes.SpecPaneView extends Backbone.View
  template: JST["templates/equipment/spec_pane"]

  events:
    "click .removeEquipment"    : "destroy"

  destroy: (event) ->
    e = event.target || event.currentTarget
    equipmentId = $(e).data('eid')

    @model.equipment.remove(equipmentId)
    @model.save(null,
        success: =>
            @render()
    )

  render: =>
    data = Array()
    @model.equipment.forEach((i) =>
        if i.get('type') == @options.type
            data.push(i.toJSON())
    )
    $(@el).html(@template(equipmentItems: data ))
    return this

class Jetdeck.Views.Airframes.ShowSendView extends Backbone.View
  template: JST["templates/airframes/partials/_send"]

  events :
    "click #send_spec" : "send"

  send : ->
    email = $("#recipient_email").val()
    $.post("/xspecs", {"xspec[recipient_email]": email, "xspec[airframe_id]": @model.get("id")})
    .success( (m) =>
      @$(".control-group").removeClass("error")
      @$(".help-inline").hide()
      if (m.recipient.id)
        new_lead = {
          email : m.recipient.email
          id : m.recipient.id
          xspecId: m.id
          url: "/s/" + m.urlCode
        }

        if m.recipient.first && m.recipient.last
          new_lead.name = m.recipient.first + " " + m.recipient.last

        @model.leads.add(new_lead)
        @model.parentView.show_leads()
    )
    .error( (m) =>
      @$(".control-group").addClass("error")
      @$(".help-inline").show()
    )

  render : ->
    $(@el).html(@template(@model.toJSON() ))
    return this

class Jetdeck.Views.Airframes.ShowLeadsView extends Backbone.View
  template: JST["templates/airframes/partials/_leads"]

  initialize: () ->
    @on('add', @addAll, @model.leads)

  events : 
    "click a.next" : "next"
    "click a.prev" : "prev"
    "click a.page" : "page"
    "click .sort"  : "sort"
  
  sort : (event) ->
    # capture the click and get the parameters
    e = event.target || event.currentTarget
    sort = $(e).data('sort')  
    direction = $(e).data('dir')  
    
    # perform the sort
    @model.leads.orderBy(sort)
    @model.leads.direction(direction)
    @model.leads.sort()  
    
    # set the sort button styles
    #@$('.sort').parent("li").removeClass('active')
    #@$(e).parent("li").addClass('active')
    @$(".sort_dir_icon").remove()
    if direction == "asc"
        @$(e).append("<i class='icon-chevron-down sort_dir_icon'></i>")    
    if direction == "desc"
        @$(e).append("<i class='icon-chevron-up sort_dir_icon'></i>")  
           
    # toggle sort button direction
    $(e).data('dir', 'desc') if direction == "asc"
    $(e).data('dir', 'asc') if direction == "desc"    
        
    # go back to first page  
    @model.leads.turnTo(1)
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    @$('.page[rel=1]').parent('li').addClass('active')
    
  page : (event) ->
    e = event.target || event.currentTarget
    n = $(e).attr('rel')
    @model.leads.turnTo(n)
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    $(e).parent('li').addClass('active')
    
  next : ->
    @model.leads.next()
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    p = @model.leads.currentPage()
    @$('.page[rel='+p+']').parent('li').addClass('active')    

  prev : ->
    @model.leads.prev()
    @addAll()
    @$('a.page').parent('li').removeClass('active')
    p = @model.leads.currentPage()
    @$('.page[rel='+p+']').parent('li').addClass('active')    

  addAll: =>
    @clear()
    @model.leads.eachOnPage(@addOne)

  clear : ->
    @$("tbody").html('')
    
  addOne: (lead) => 
    if lead
        view = new Jetdeck.Views.Airframes.EntryView({model : lead})
        @$("tbody").append(view.render().el)
        
  render : ->
    params =
        count : @model.leads.length
        pages : @model.leads.pages()
    $(@el).html(@template(params))
    @addAll()    
    @$('.page[rel=1]').parent('li').addClass('active')  
    return this

class Jetdeck.Views.Airframes.EntryDestroy extends Backbone.View
  template : JST["templates/spec/_confirm_delete"]
  
  tagName: "div"
  
  events:
    "click .confirm_remove_lead"    : "confirmRemoveLead"
    
  confirmRemoveLead: () =>
    xid = @model.get('xspecId')
    @model.url = "/xspecs/" + xid
    @model.destroy()
    window.router.view.render()
    modalClose()
    return this
    
  render : ->
    $(@el).html(@template(@model.toJSON() ))
    return this     
      
class Jetdeck.Views.Airframes.EntryView extends Backbone.View
  template : JST["templates/airframes/partials/_lead_entry"]
  
  tagName : "tr"
  
  events:
    "click .xspec_settings"             : "xspecSettings"
    "click .remove_xspec"           : "removeSpec"

  removeSpec: () =>
    confirmDelete = new Jetdeck.Views.Airframes.EntryDestroy(model: @model)
    modal(confirmDelete.render().el)
    return this  
    
  xspecSettings: () ->
    specModel = new Jetdeck.Models.Spec(id: n)
    specModel.fetch(
        success: () ->
            specView = new Jetdeck.Views.Spec.EditView(model: this)
            modal(specView.render())    
    )
    return this
      
  render : ->
    $(@el).html(@template(@model.toJSON() ))
    return this                  
