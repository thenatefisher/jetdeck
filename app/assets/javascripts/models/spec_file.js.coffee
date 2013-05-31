class Jetdeck.Models.SpecFileModel extends Backbone.Model
  paramRoot: 'spec_file'

  defaults:
    name: null

class Jetdeck.Collections.SpecFilesCollection extends Backbone.CollectionBook
  model: Jetdeck.Models.SpecFileModel
  url: '/accessories'

