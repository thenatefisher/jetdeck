Jetdeck.Views.Airframes ||= {}

class Jetdeck.Views.Airframes.ShowSpecs extends Backbone.View
  template: JST["templates/airframes/specs/specs"]

  events:
    "click .add-spec" : "add"
    "click .cancel" : "refreshView"

  initialize: =>
    @showHidden = false

  toggleHidden: =>
    @showHidden = !@showHidden
    @render()

  add: =>
    @$("#airframe-document-input").click()

  renderUploader: =>
    # uploader instantiation and settings
    @$("#airframe_document_upload").fileupload({
        autoUpload: true
        url: "/airframe_specs"
        acceptFileTypes: /(\.|\/)(word|pdf|doc|docx)$/i
        maxFileSize: 10490000 # 10MB
    })

    # show progress when started
    @$("#airframe_document_upload").bind("fileuploadstarted", => @$("#new-spec-well").show()) 
    # refresh spec list when uploaded
    @$("#airframe_document_upload").bind("fileuploaddone", => @refreshView()) 

    # set CSRF token
    token = $("meta[name='csrf-token']").attr("content")
    @$("#airframe_document_upload input[name='authenticity_token']").val(token)   

  refreshView: =>
    @$("#new-spec-well").hide()
    @model.fetch( success: => 
      @model.updateChildren()
      @render() 
    )

  renderSpecs: =>
    @model.specs.each((spec) =>   
      view = new Jetdeck.Views.Airframes.Spec({model : spec, showHidden: @showHidden})
      view.on("clicked-send", (data) => @send(data))
      view.on("clicked-disable", (data) => @disable(data))
      @$("#specs-table tbody").append(view.render().el) if view
    )

    # show hidden button
    @$(".show-hidden").on("click", => @toggleHidden())

    # remove top border on first table item 
    @$("tbody").children("tr").first().children("td").css("border-top", "0px")

  render: =>
    # render out main template
    $(@el).html(@template(@model.toJSON()))
  
    # setup file uploader when DOM is ready
    @$("#new-spec-well").hide()
    $(() => @renderUploader())

    if @model.specs.length < 1
      @$("#specs-populated").hide()
      @$("#specs-empty").show()
    else
      @$("#specs-populated").show()
      @$("#specs-empty").hide()
      @renderSpecs()

    return this

class Jetdeck.Views.Airframes.Spec extends Backbone.View
  template: JST["templates/airframes/specs/spec_item"]

  tagName: "tr"

  send: (spec) =>
    view = new Jetdeck.Views.Specs.Send(airframe: @model, spec: spec)
    modal(view.render().el)

  disable: (spec) =>
    enabled = spec.get("enabled")
    spec.save({enabled: !enabled}, success: => @render())

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

