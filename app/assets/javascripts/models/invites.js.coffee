class Jetdeck.Models.InviteModel extends Backbone.Model
    paramRoot: "invite"

    defaults:
      name: null
      email: null
      message: null

class Jetdeck.Collections.InvitesCollection extends Backbone.Collection

    model: Jetdeck.Models.InviteModel
    
    url: "/invites"
    
