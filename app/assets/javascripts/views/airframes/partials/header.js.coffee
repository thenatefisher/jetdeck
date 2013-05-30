Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.ShowHeader extends Backbone.View
  template: JST['templates/airframes/partials/header']

  events:
    'click .set-thumbnail' : 'setThumbnail'

  initialize: () ->
    @model.on('change', @updateHeadline)

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

    $.widget('blueimp.fileupload', $.blueimp.fileupload, {
        _renderExtendedProgress: (data) ->
            this._formatPercentage(data.loaded / data.total) + '  (' + this._formatBitrate(data.bitrate) + ')'
    })

    # uploader instantiation and settings
    @$('#airframe_image_upload').fileupload({
        autoUpload: true
        url: '/accessories'
        acceptFileTypes: /^image\/(gif|jpeg|png)$/
        maxFileSize: 10490000 # 10MB
        progressall: (e, data) =>
            progress = parseInt(data.loaded / data.total * 100, 10)
            globalProgressNode = @$('.fileupload-progress')
            extendedProgressNode = globalProgressNode.find('.progress-extended')
            if (extendedProgressNode.length) 
                extendedProgressNode.html(
                    @$('#airframe_image_upload').data('blueimp-fileupload')._renderExtendedProgress(data)
                )   
            globalProgressNode
                .find('.progress')
                .attr('aria-valuenow', progress)
                .find('.bar').css(
                    'width',
                    progress + '%'
                )
                         
    })

    # reflow header on image upload and delete
    @$('#airframe_image_upload').bind('fileuploaddestroyed', => @reflow())
    @$('#airframe_image_upload').bind('fileuploadfinished', => @reflow())

    # set some drag/drop events
    @$('#airframe_image_upload').bind('fileuploaddrop', =>
        $('#uploader').show()
        mixpanel.track('Added Image To Airframe', {method: 'drag-drop'})
    )

    # set CSRF token
    token = $("meta[name='csrf-token']").attr("content")
    @$("#airframe_image_upload input[name='authenticity_token']").val(token)    

    # initial image readout
    @reflow(false)
    
  reflow: (show_image_list=true) =>

    # get all existing images
    $.getJSON('/accessories/?airframe=' + @model.get('id'),  (files) =>
        fu = $('#airframe_image_upload').data('blueimpFileupload')
        $('#airframe_image_upload .files').html("")
        fu._renderDownload(files)
            .appendTo($('#airframe_image_upload .files'))
            .removeClass('fade')       
    )

    $('#uploader').show() if show_image_list

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
