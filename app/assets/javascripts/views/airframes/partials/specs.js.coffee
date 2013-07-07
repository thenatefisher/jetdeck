Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.ShowSpecs extends Backbone.View
  template: JST["templates/airframes/specs/specs"]

  events:
    "click .add-spec" : "add"
    "click .cancel" : "refreshView"

  add: =>
    @$("#airframe-document-input").click()

  renderUploader: =>
    # uploader instantiation and settings
    @$("#airframe_document_upload").fileupload({
        autoUpload: true
        dropZone: null
        url: "/airframe_specs"
        acceptFileTypes: /(\.|\/)(word|pdf|doc|docx)$/i
        maxFileSize: 209800000 # 20MB
    })

    # show progress when started
    @$("#airframe_document_upload").bind("fileuploadstarted", => @startedUpload()) 
    # refresh spec list when uploaded
    @$("#airframe_document_upload").bind("fileuploaddone", => @refreshView()) 
    # failed
    @$("#airframe_document_upload").bind("fileuploadfailed", (event, object) => @showUploadError(object)) 

    # set CSRF token
    token = $("meta[name='csrf-token']").attr("content")
    @$("#airframe_document_upload input[name='authenticity_token']").val(token)   

  startedUpload: =>
    @$("#new-spec-table").addClass("spec-upload-table")

  refreshView: =>
    mixpanel.track("Uploaded Spec")
    @$("#new-spec-table").removeClass("spec-upload-table")
    @model.fetch( success: => 
      @model.updateChildren()
      @render() 
    )

  showUploadError: (object) =>
    mixpanel.track("Failed Spec Upload")
    message = $.parseJSON(object.jqXHR.responseText)[0]
    @$("#new-spec-table").html(message).addClass("error")

  send: (spec) =>
    view = new Jetdeck.Views.Specs.Send(airframe: @model, spec: spec)
    modal(view.render().el)

  disable: (spec) =>
    mixpanel.track("Disabled Spec")
    spec.save({enabled: false}, success: => @render())

  renderSpecs: =>
    @model.specs.each((spec) =>  
      if spec.get("enabled") == true
        view = new Jetdeck.Views.Airframes.Spec({model : spec})
        view.on("clicked-send", (data) => @send(data))
        view.on("clicked-disable", (data) => @disable(data))
        @$("#specs-table tbody").append(view.render().el) if view
    )

    # remove top border on first table item 
    @$("tbody").children("tr").first().children("td").css("border-top", "0px")

  render: =>
    # render out main template
    $(@el).html(@template(@model.toJSON()))

    $(() => 
      @renderUploader()
      @renderSpecs()
    )

    if @model.specs.where({enabled: "true"}).length < 1
      @$("#specs-populated").hide()
      @$("#specs-empty").show()
    else
      @$("#specs-populated").show()
      @$("#specs-empty").hide()


    return this

class Jetdeck.Views.Airframes.Spec extends Backbone.View
  template: JST["templates/airframes/specs/spec_item"]

  tagName: "tr"

  render: =>
    if @model.get("enabled") || (@options && @options.showHidden)
      updated_string = convert_time(@model.get("created_at"))
      @model.set("updated", updated_string)  
      $(@el).html(@template(@model.toJSON() ))
      @$(".send").on("click", => @trigger("clicked-send", @model))
      @$(".disable").on("click", => @trigger("clicked-disable", @model))
      if !@model.get("enabled")
        $(@el).addClass("error") 
        @$(".disable").html("Enable")
        @$(".send").attr("disabled", "disabled")

    return this

