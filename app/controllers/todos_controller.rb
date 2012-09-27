class TodosController < ApplicationController
  before_filter :authorize
  
  def index
  
    @actions = Action.find(:all, :conditions => ["created_by = ?", @current_user.id])
    if !@actions.empty?
      render :json => @actions.to_json
    else
      render :json => true
    end
    
  end

  def create
  
    if params[:action][:actionable_id] && 
      (params[:action][:actionable_type] == "Contact" || 
      params[:action][:actionable_type] == "Airframe")
      
      whitelist = params[:action].slice(:title, :description, :is_completed, :due_at)

      @action = Action.new(whitelist)
      @action.created_by = @current_user.id
      @action.actionable_type = params[:action][:actionable_type]
      @action.actionable_id = params[:action][:actionable_id]
      
      respond_to do |format|
        if @action.save
          format.html { redirect_to @action, :notice => 'Action was successfully created.' }
          format.json { render :json => @action, :status => :created, :location => @action }
        else
          format.html { render :action => "new" }
          format.json { render :json => @action.errors, :status => :unprocessable_entity }
        end
      end
    end
    
  end  

  def update
  
    @action = Action.find(:first, :conditions => ["id = ? AND created_by = ?", params[:id], @current_user.id])

    whitelist = params[:action].slice(:title, :description, :is_completed, :due_at)

    respond_to do |format|
      if @action.update_attributes(whitelist)
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @action.errors, :status => :unprocessable_entity }
      end
    end
    
  end

  def destroy
  
    @action = Action.find(:first, :conditions => ["id = ? AND created_by = ?", params[:id], @current_user.id])
    @action.destroy
    render :json => true
    
  end
end
