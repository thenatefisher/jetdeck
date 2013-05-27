Jetdeck.Views.Profile ||= {}

class Jetdeck.Views.Profile.ShowView extends Backbone.View
  template: JST["templates/profile/show"]
  
  render: ->
    $(@el).html(@template(@model.toJSON() ))

    # setup editable fields
    @$('#first').editable({url: (obj) => @model.attributes.contact[obj.name] = obj.value; @model.save()})
    @$('#last').editable({url: (obj) => @model.attributes.contact[obj.name] = obj.value; @model.save()})
    @$('#company').editable({url: (obj) => @model.attributes.contact[obj.name] = obj.value; @model.save()})
    @$('#title').editable({url: (obj) => @model.attributes.contact[obj.name] = obj.value; @model.save()})
    @$('#phone').editable({url: (obj) => @model.attributes.contact[obj.name] = obj.value; @model.save()})
    @$('#signature').editable({url: (obj) => @model.attributes.contact[obj.name] = obj.value; @model.save()})
    @$('#password').editable({
      url: (obj) =>       
        console.log obj
        @model.set('password', obj.value.password)
        @model.set('password_confirmation', obj.value.password_confirmation)  
        @model.save()
    })
    @$('#website').editable({
      url: (obj) => 
        website = obj.value.replace(/http\:\/\//, '')
        website = 'http://' + website
        @model.attributes.contact[obj.name] = website
        @model.save()
      success: (response, newValue) =>
        return {newValue: response.website}
    })    

    return this
