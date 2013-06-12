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
    if headline.length >= 25
      $('#spec_headline').css('fontSize', '33px')
    else
      $('#spec_headline').css('fontSize', '39px')
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
        acceptFileTypes: /(\.|\/)(gif|png|jpg|jpeg)$/i
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
    
    @updateHeadline()

    @$("#chart").ready( =>
        graph = new Rickshaw.Graph( {
          element: document.querySelector("#chart")
          width: 260
          height: 80
          renderer: 'area'
          stroke: true
          series: [ 
              {
                data: [ { x: 0, y: 4 },{ x: 1, y: 4 },{ x: 2, y: 5 },{ x: 3, y: 5},{ x: 4, y: 6 },{ x: 5, y: 7 },{ x: 6, y: 7 }, 
                    { x: 7, y: 7 },{ x: 8, y: 7 },{ x: 9, y: 8 },{ x: 10, y: 9 },{ x: 11, y: 10 },{ x: 12, y: 11 },{ x: 13, y: 12 }
                ]
                color: 'rgba(44, 62, 80,0.5)'
                stroke: 'rgba(44, 62, 80,0.15)'
                name: 'Downloads'
              } 
          ]
        } )
        hoverDetail = new Rickshaw.Graph.HoverDetail( {
            graph: graph
            xFormatter: (x) -> return "05/"+x+"/2013"
            yFormatter: (y) -> return Math.floor(y) + " views" 
        } )

        graph.renderer.unstack = true
        graph.render()        
    )
        
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
