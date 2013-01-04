this.editInline = (model, fname, value) ->
  model.set(fname, value)
  model.save(null)