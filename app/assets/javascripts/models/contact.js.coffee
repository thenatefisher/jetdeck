class Jetdeck.Models.ContactModel extends Backbone.Model
    paramRoot: "contact"

    defaults:
        company: null
        first: null
        last: null
        email: null
        phone: null

class Jetdeck.Collections.ContactCollection extends Backbone.CollectionBook
    model: Jetdeck.Models.ContactModel
    url: "/contacts"
