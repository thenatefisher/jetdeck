Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.ShowHeader extends Backbone.View
  template: JST['templates/airframes/partials/header']

  events:
    'click .set-thumbnail' : 'setThumbnail'

  initialize: () ->
    @model.on('change', @updateHeadline)
    @$('.fileinput-button').on('click', (e) -> e.preventDefault())

  updateHeadline: () =>
    headline = @model.get('year')
    headline += ' ' + @model.get('make')
    headline += ' ' + @model.get('model_name')
    $('#spec_headline').html(headline)
    return this
      
  setThumbnail: (event) ->
    e = event.target || event.currentTarget
    event.preventDefault()
    accessoryId = $(e).data('aid')
    $.ajax( {
        url: '/accessories/' + accessoryId, 
        data: {thumbnail: true},
        type: 'PUT',
        success: => 
            @model.fetch(
                success: => 
                    window.router.view.header.render()
                    $('#uploader').show()
            )
        }
    )

  loadAccessories: () =>

    # instantiate file uploader
    @$('#airframe_image_upload').fileupload()

    # uploader settings
    @$('#airframe_image_upload').fileupload({
        autoUpload: true
        url: '/accessories'
        acceptFileTypes: /^image\/(gif|jpeg|png)$/
        maxFileSize: 10490000 # 10MB
    })

    @$('#airframe_image_upload').bind('fileuploaddestroyed', -> window.router.view.header.render())

    # open edit box when adding via the button
    @$('#airframe_image_upload').bind('fileuploadadd', ->
      $("#changes").children().fadeIn()
      $("#changes").slideDown()
    )
    
    # set some drag/drop events
    @$('#airframe_image_upload').bind('fileuploaddrop', =>
      $('#uploader').show()
      #mixpanel.track('Dropped Image Into Airframe')
    )

    # get all existing images
    $.getJSON('/accessories/?airframe=' + @model.get('id'),  (files) =>
        fu = $('#airframe_image_upload').data('blueimpUIFileupload')
        fu._renderDownload(files)
            .appendTo($('#airframe_image_upload .files'))
            .removeClass('fade')
    )

    token = $("meta[name='csrf-token']").attr("content")
    @$("#airframe_image_upload input[name='authenticity_token']").val(token)    
    
  render: ->
  
    # render header
    $(@el).html(@template(@model.toJSON() ))
    
    # wait for this content to be loaded in DOM, then activate fileupload()
    $(() => @loadAccessories())

    # setup editable fields
    @$('#spec_headline').editable({
      title: 'Year, Make and Model',
      value: {
        year: @model.get('year'), 
        make: @model.get('make'), 
        modelName: @model.get('model_name')
      },
      placement: 'bottom',
      send: 'never',
      url: (obj) => 
        @model.set('year', obj.value.year)
        @model.set('make', obj.value.make)
        @model.set('model_name', obj.value.modelName)
        @model.save()
    })

    @$('#serial').editable({url: (obj) => @model.set(obj.name, obj.value); @model.save()})
    @$('#registration').editable({url: (obj) => @model.set(obj.name, obj.value); @model.save()})
    @$('#asking_price').editable({
        url: (obj) => 
            d = new $.Deferred
            intPrice = parseInt(obj.value.replace(/[^0-9]/g,''), 10)
            @model.set(obj.name, intPrice)
            @model.save(null, {success: => d.resolve()})
            return d.promise()
        display: (obj) ->
            intPrice = parseInt(obj.replace(/[^0-9]/g,''), 10)
            $(this).html('$' + intPrice.formatMoney(0, '.', ','))
        })

    @$('#asking_price').each(->
        if $(this).html() != null
          intPrice = parseInt($(this).html().replace(/[^0-9]/g,''), 10)
          $(this).html('$' + intPrice.formatMoney(0, '.', ','))
    )        
    
    return this    
