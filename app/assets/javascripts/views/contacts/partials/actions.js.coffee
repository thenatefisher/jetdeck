Jetdeck.Views.Actions ||= {}

class Jetdeck.Views.Actions.ActionItem extends Backbone.View
  template: JST["templates/actions/partials/action_item"]

  initialize: ->
    $(@el).click( =>
      @model.save(
        { is_completed: true }, 
        success: => 
          $(@el).fadeOut(300, => @trigger("deleted"))
          mixpanel.track("Closed Action")
      )
    )

    $(@el).hover( 
      => 
        @$(".action-buttons").show()
        @$(".long-title").show()
        @$(".short-title").hide()
      ,
      => 
        @$(".action-buttons").hide()
        @$(".long-title").hide()
        @$(".short-title").show()
    )
  
  render : =>
    $(@el).html(@template(@model.toJSON() ))
    return this
  
class Jetdeck.Views.Actions.ShowActions extends Backbone.View
  template: JST["templates/actions/partials/actions"]
    
  initialize: =>
    @type = window.router.view.model.paramRoot.charAt(0).toUpperCase() + window.router.view.model.paramRoot.slice(1)
    @fup_name = "With " + @type
    if @type == "Contact"
      @fup_name= "With " + @model.get("first") if @model.get("first")
    if @type == "Airframe"
      @fup_name= "With " + @model.get("model_name") + " " + @model.get("serial") if @model.get("serial") 
      @fup_name= "With " + @model.get("registration") if @model.get("registration")      
    
  events:
    "click #add-action" : "create"
    "click .fup-action" : "fup"
    
  fup: (event) =>
    e = event.target || event.currentTarget
    interval = $(e).data("interval")
    
    action = new Jetdeck.Models.ActionModel()
    action.collection = @model.actions
    action.save({
      title: "Follow Up " + @fup_name, 
      interval: interval,
      actionable_type: @type, 
      actionable_id: @model.get('id')
    }, success: (m) => 
      mixpanel.track "Created Canned Action", {type: @type}
      @model.actions.add(m)
      @render()
    )  
    
  create: =>
    if !@$("textarea").val()
      @$(".control-group").addClass("error")
      return 
      
    action = new Jetdeck.Models.ActionModel()
    action.collection = @model.actions
    action.set({
      title: @$("textarea").val(), 
      actionable_type: @type, 
      actionable_id: @model.get('id')
    })
    action.set({due_at: @$("#due_at").val()}) if @$("#due_at").val() != ""
    action.save(null, 
      success: (m) => 
        mixpanel.track "Created Action", {type: @type}
        @model.actions.add(m)
        @render()
    )
        
  render : =>
    $(@el).html(@template())

    @model.actions.sort()
    @model.actions.each( (action) =>
      item = new Jetdeck.Views.Actions.ActionItem(model: action)
      @$("#actions").append(item.render().el) if action.get('is_completed') != true
      item.on("deleted", @render)
    )

    if @model.actions.where({is_completed: false}).length == 0
      @$("#add-action-fields").show()
    else
      @$(".subsection").toggle(
        => @$("#add-action-fields").show(),
        => @$("#add-action-fields").hide()
      )   

    return this

  datepicker: =>
    @$('#due_at_datepicker').datepicker()
    .on('changeDate', (event) =>
      curr_date = event.date.getDate();
      curr_month = event.date.getMonth() + 1;
      curr_year = event.date.getFullYear();
      dstring = curr_month + "/" + curr_date + "/" +  curr_year;  
      @$("#due_at").val(curr_year + "-" + curr_month + "-" + curr_date;)  
      @$("#due_at_datepicker span").html("Due: " + curr_month + "/" + curr_date + "/" +  curr_year;)
      $(".datepicker.dropdown-menu").hide()
    )      
