class Jetdeck.Models.ContactModel extends Backbone.Model
    paramRoot: "contact"

    defaults:
        company: null
        first: null
        last: null
        email: null
        phone: null
        
    initialize : =>
      ## specs collection
      @specs = new Jetdeck.Collections.SpecsCollection(page_size: 10)
      @specs.contact = this
      
      ## populate child collections
      @updateChildren()
      
    updateChildren : =>
      @specs.reset @get('specs')
        
class Jetdeck.Collections.ContactCollection extends Backbone.CollectionBook
    model: Jetdeck.Models.ContactModel
    url: "/contacts"
