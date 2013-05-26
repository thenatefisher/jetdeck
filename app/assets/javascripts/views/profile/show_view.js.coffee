Jetdeck.Views.Profile ||= {}

class Jetdeck.Views.Profile.ShowView extends Backbone.View
  template: JST["templates/profile/show"]
  
  save: (e) =>

    @model.set('spec_disclaimer', @$("textarea[name='spec_disclaimer']").val())
    
    $(".inline-edit").each( ->
      
      # strip leading/trailing space
      this.value = this.value.replace(/(^\s*)|(\s*$)/gi,"")
      this.value = this.value.replace(/\n /,"\n")
      self.model.attributes.contact[this.name] = this.value

    )
    
    # add protocol onto website url
    website = @model.attributes.contact['website']
    website = website.replace(/http\:\/\//, '')
    website = 'http://' + website
    @model.attributes.contact['website'] = website

    @model.save(null,
      success: (response) =>
        $("#changes").children().fadeOut()
        $("#changes").slideUp(=>
          window.router.view.render()
          alertSuccess("<i class='icon-ok icon-large'></i> Changes Saved!") 
        )
        if $("#logo").val() != ""
          token = $("meta[name='csrf-token']").attr("content")
          $("input[name='authenticity_token']").val(token)
          $("form").submit()

      error: (model, error) =>
        alertFailure(
          "<i class='icon-warning-sign icon-large'></i> Error Saving Changes"
        )
        errorStruct = JSON.parse(error.responseText)      
        $(".error[for='"+e+"']").html(errorStruct[e].toString()) for e of errorStruct

    )
    
    $("#save-changes").prop('disabled', false)

    
  render: ->
    $(@el).html(@template(@model.toJSON() ))

    # setup editable fields
    @$('#first').editable({url: (obj) => @model.attributes.contact[obj.name] = obj.value; @model.save()})
    @$('#last').editable({url: (obj) => @model.attributes.contact[obj.name] = obj.value; @model.save()})
    @$('#company').editable({url: (obj) => @model.attributes.contact[obj.name] = obj.value; @model.save()})
    @$('#title').editable({url: (obj) => @model.attributes.contact[obj.name] = obj.value; @model.save()})
    @$('#phone').editable({url: (obj) => @model.attributes.contact[obj.name] = obj.value; @model.save()})

    return this
