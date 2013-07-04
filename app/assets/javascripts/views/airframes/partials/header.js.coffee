Jetdeck.Views.Airframes ||= {}
Jetdeck.Views.Airframes.Header ||= {}

class Jetdeck.Views.Airframes.Header.Editable extends Backbone.View
  template: JST["templates/airframes/header/editable"]

  initialize: () ->
    @model.on('change', @renderHeadline)

  renderHeadline: () =>
    headline = @model.get("year")
    headline += " " + @model.get("make")
    headline += " " + @model.get("model_name")
    $("#headline").html(headline)
    if headline.length >= 25
      $("#headline").css("fontSize", "33px")
    else
      $("#headline").css("fontSize", "39px")
    return this

  initializeEditableFields: =>
    # setup editable fields
    @$("#headline").editable({
      title: "Year, Make and Model",
      value: {
      year: @model.get("year")
      make: @model.get("make")
      modelName: @model.get("model_name")
      }
      placement: "bottom"
      send: "never"
      url: (obj) =>
        @model.save({
          year: obj.value.year
          make: obj.value.make
          model_name: obj.value.modelName
        } )
    } )
    @$("#serial").editable({url: (obj) => @model.save(obj.name, obj.value)})
    @$("#registration").editable({url: (obj) => @model.save(obj.name, obj.value) } )
    @$("#asking_price").editable({
      url: (obj) =>
        d = new $.Deferred
        intPrice = parseInt(obj.value.replace(/[^0-9]/g, ""), 10)
        @model.set(obj.name, intPrice)
        @model.save(null, {success: => d.resolve() } )
        return d.promise()
      display: (obj) ->
        intPrice = parseInt(obj.replace(/[^0-9]/g, ""), 10)
        $(this).html("$" + intPrice.formatMoney(0, ".", ",") )
      } )

    @$("#asking_price").each(->
      if $(this).html() != null
        intPrice = parseInt($(this).html().replace(/[^0-9]/g, ""), 10)
        $(this).html("$" + intPrice.formatMoney(0, ".", ",") )
    )

  render: =>
    # render header container
    $(@el).html(@template(@model.toJSON() ) )

    # wait for container content to be loaded in DOM
    $(() =>
      # init editable fields
      @initializeEditableFields()
      # render headline
      @renderHeadline()
    )

    return this

class Jetdeck.Views.Airframes.Header.Avatar extends Backbone.View
  tmpl_empty: JST["templates/airframes/header/avatar_empty"]
  tmpl_filled: JST["templates/airframes/header/avatar_filled"]

  render: =>
    $(@el).html(@tmpl_empty() )
    if @model && @model.get("avatar")
      $(@el).html(@tmpl_filled({avatar: @model.get("avatar") } ) )
    return this

class Jetdeck.Views.Airframes.Header.Show extends Backbone.View
  template: JST['templates/airframes/header/header']

  events:
    "click .set-thumbnail"    : "setThumbnail"
    "click .manage-images"    : "manageImages"

  manageImages: () ->
    if $("#uploader").is(":visible")
      $("#uploader").hide()
    else
      $("#uploader").show()

  initialize: () ->
    @setThumbnailMutex = false

  setThumbnail: (event) ->
    # dont refresh page
    event.preventDefault()

    # this mitigates damage from repeatedly
    # hammering the set thumbnail button
    if @setThumbnailMutex == false
      @setThumbnailHelper(event)

  setThumbnailHelper: (event) ->
    # lock set thumbnail mutex
    @setThumbnailMutex = true

    # capture image from dom attributes and click event
    e = event.target || event.currentTarget
    image_id = $(e).data("aid")
    image = @model.images.where({id: image_id})[0]

    # if we found one, update thumbnail field
    if image
      @model.images.forEach((im) -> im.set({thumbnail: false} ) )
      image.set({thumbnail: true} )
      @model.save(null, {success: =>
        # refresh avatar
        @renderAvatar()
        # reload image list to set thumbnail button state
        @renderImagesList()
        # unlock mutex
        @setThumbnailMutex = false
      } )
    else
      # unlock set thumbnail mutex
      @setThumbnailMutex = false

  renderAvatar: =>
    avatar_view = new Jetdeck.Views.Airframes.Header.Avatar(model: @model)
    @$("#airframe-thumbnail").html(avatar_view.render().el)

  renderEditable: =>
    editable_view = new Jetdeck.Views.Airframes.Header.Editable(model: @model)
    @$("#airframe-editable").html(editable_view.render().el)

  initializeImagesUploader: () =>
    # format transfer progress output
    $.widget("blueimp.fileupload", $.blueimp.fileupload, {
      _renderExtendedProgress: (data) ->
        this._formatPercentage(data.loaded / data.total) + "  (" + this._formatBitrate(data.bitrate) + ")"
    } )

    # uploader instantiation and settings
    @$("#airframe_image_upload").fileupload({
      autoUpload: true
      dropZone: null
      url: "/airframe_images"
      acceptFileTypes: /(\.|\/)(gif|png|jpg|jpeg)$/i
      maxFileSize: 10490000 # 10MB
      progressall: (e, data) =>
        progress = parseInt(data.loaded / data.total * 100, 10)
        globalProgressNode = @$(".fileupload-progress")
        extendedProgressNode = globalProgressNode.find(".progress-extended")
        if (extendedProgressNode.length)
          extendedProgressNode.html(
            @$("#airframe_image_upload").data("blueimp-fileupload")._renderExtendedProgress(data)
          )
        globalProgressNode
          .find(".progress")
          .attr("aria-valuenow", progress)
          .find(".bar").css(
            "width",
            progress + "%"
          )
    } )

    # re-render avatar thumbnail
    @$("#airframe_image_upload").bind("fileuploaddestroyed", =>
      @model.unset("avatar") ; @model.fetch(complete: => @renderAvatar() ) )
    @$("#airframe_image_upload").bind("fileuploadfinished", =>
      @model.unset("avatar") ; @model.fetch(complete: => @renderAvatar() ) )

    # set some drag/drop events
    @$("#airframe_image_upload").bind("fileuploaddrop", =>
      $("#uploader").show()
      mixpanel.track("Added Image To Airframe", {method: "drag-drop"} )
    )

    # set CSRF token
    token = $("meta[name='csrf-token']").attr("content")
    @$("#airframe_image_upload input[name='authenticity_token']").val(token)

  renderImagesList: =>
    # clear list
    uploader = $("#airframe_image_upload").data("blueimpFileupload")
    $("#airframe_image_upload .files").html("")

    # add all images
    uploader._renderDownload(@model.images.toJSON() )
      .appendTo($("#airframe_image_upload .files") )
      .removeClass("fade")

  render: ->
    # render header container
    $(@el).html(@template(@model.toJSON() ) )

    # wait for container content to be loaded in DOM
    $(() =>
      # render avatar
      @renderAvatar()
      # render editable
      @renderEditable()
      # init image uploader
      @initializeImagesUploader()
      # render images list
      @renderImagesList()
    )

    return this
