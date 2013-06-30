class TodosController < ApplicationController
  before_filter :authorize, :sanitize_params

  def index

    @actions = Todo.find(:all, :conditions => ["is_completed != 'true' AND created_by = ?", @current_user.id])

  end

  def create

    if params[:todo][:actionable_id] &&
        (params[:todo][:actionable_type] == "Contact" ||
         params[:todo][:actionable_type] == "Airframe")

        whitelist = params[:todo].slice(:title, :description, :is_completed)

      @action = Todo.new(whitelist)
      @action.created_by = @current_user.id
      @action.actionable_type = params[:todo][:actionable_type]
      @action.actionable_id = params[:todo][:actionable_id]
      @action.due_at = Time.now + Integer(params[:todo][:interval]).months if
      (params[:todo][:interval] && (Integer(params[:todo][:interval]) rescue false))

      if params[:todo][:due_at].present?
        date_string = params[:todo][:due_at].split("-") rescue nil
        @action.due_at = Time.new(date_string[0], date_string[1], date_string[2]) rescue nil
      end

      respond_to do |format|
        if @action.save
          format.json {render :locals => {action: @action}, :template => "todos/show", :formats => [:json], :handlers => [:jbuilder]}
        else
          format.html { render :action => "new" }
          format.json { render :json => @action.errors, :status => :unprocessable_entity }
        end
      end
    end

  end

  def update

    @action = Todo.find(:first, :conditions => ["id = ? AND created_by = ?", params[:id], @current_user.id])

    whitelist = params[:todo].slice(:title, :description, :is_completed, :due_at)

    respond_to do |format|
      if @action.update_attributes(whitelist)
        format.json {render :locals => {action: @action}, :template => "todos/show", :formats => [:json], :handlers => [:jbuilder]}
      else
        format.html { render :action => "edit" }
        format.json { render :json => @action.errors, :status => :unprocessable_entity }
      end
    end

  end

  def destroy
    @todo = Todo.first(:first, :conditions => ["id = ? AND created_by = ?", params[:id], @current_user.id])
    if @todo && @todo.destroy()
      render :json => :true, :status => :ok
    else
      render :json => ["Not authorized to delete"], :status => :unprocessable_entity
    end
  end
end
