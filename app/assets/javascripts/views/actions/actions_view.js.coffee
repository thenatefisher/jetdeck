Jetdeck.Views.Actions ||= {}

class Jetdeck.Views.Actions.ActionItem extends Backbone.View
  template: JST["templates/actions/action_item"]

  events: 
    "click .close-action" : "close"
    
  close: =>
    @model.save({is_completed: true}, success: => 
      $(@el).fadeOut(300, => @trigger("deleted"))
      mixpanel.track("Closed Action")
    )
    
  initialize: ->
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
  template: JST["templates/actions/actions"]
    
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
    
    action = new Jetdeck.Models.TodoModel()
    action.collection = @model.todos
    action.save({
      title: "Follow Up " + @fup_name, 
      interval: interval,
      actionable_type: @type, 
      actionable_id: @model.get('id')
    }, success: (m) => 
      mixpanel.track "Created Canned Action", {type: @type}
      @model.todos.add(m)
      @render()
    )  
    
  create: =>
    if !@$("textarea").val()
      @$(".control-group").addClass("error")
      return 
      
    action = new Jetdeck.Models.TodoModel()
    action.collection = @model.todos
    action.set({
      title: @$("textarea").val(), 
      actionable_type: @type, 
      actionable_id: @model.get('id')
    })
    action.set({due_at: @$("#due_at").val()}) if @$("#due_at").val() != ""
    action.save(null, 
      success: (m) => 
        mixpanel.track "Created Action", {type: @type}
        @model.todos.add(m)
        @render()
    )
        
  render : =>
    $(@el).html(@template())

    @model.todos.sort()
    @model.todos.each( (action) =>
      item = new Jetdeck.Views.Actions.ActionItem(model: action)
      @$("#actions").append(item.render().el) if action.get('is_completed') != true
      item.on("deleted", @render)
    )

    if @model.todos.where({is_completed: false}).length == 0
      @$("#add-action-fields").show()
    else
      @$(".subsection").toggle(
        => @$("#add-action-fields").show(),
        => @$("#add-action-fields").hide()
      )   

    @$('#due_at_string').datepicker().on('changeDate', (event) =>

      curr_date = event.date.getUTCDate();
      curr_month = event.date.getUTCMonth() + 1;
      curr_year = event.date.getFullYear();

      @$("#due_at").val(curr_year + "-" + curr_month + "-" + curr_date)  

      @$("#due_at_string").html("Due: " + curr_month + "/" + curr_date + "/" +  curr_year)

      $("#due_at_string").datepicker('hide')

    )      

    return this