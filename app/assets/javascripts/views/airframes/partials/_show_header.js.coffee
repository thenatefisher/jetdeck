Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.ShowHeader extends Backbone.View
  template: JST["templates/airframes/partials/_header"]

  initialize: () ->
    @model.on("change", @updateHeadline)
    return this

  updateHeadline: () =>
    headline = @model.get('year')
    headline += " " + @model.get('make')
    headline += " " + @model.get('modelName')
    $("#spec_headline").html(headline)
    return this

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
