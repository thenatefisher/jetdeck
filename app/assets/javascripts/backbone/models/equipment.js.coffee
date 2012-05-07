class Jetdeck.Models.EquipmentModel extends Backbone.Model
    paramRoot: "equipment"

class Jetdeck.Collections.EquipmentCollection extends Backbone.Collection
    model: Jetdeck.Models.EquipmentModel
    url: "/equipment"
