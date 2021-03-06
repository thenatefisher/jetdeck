class NotesController < ApplicationController
  before_filter :authorize, :sanitize_params

  def index

    @notes = Note.find(:all, :conditions => ["created_by = ?", @current_user.id])
    if !@notes.empty?
      render :json => @notes.to_json
    else
      render :json => true
    end

  end

  def create

    if params[:note][:notable_id] &&
        (params[:note][:notable_type] == "Contact" ||
         params[:note][:notable_type] == "Airframe")

        whitelist = params[:note].slice(:title, :description)

      @note = Note.new(whitelist)
      @note.created_by = @current_user.id
      @note.notable_type = params[:note][:notable_type]
      @note.notable_id = params[:note][:notable_id]

      respond_to do |format|
        if @note.save
          format.json {render :locals => {note: @note}, :template => "notes/show", :formats => [:json], :handlers => [:jbuilder]}
        else
          format.html { render :action => "new" }
          format.json { render :json => @note.errors, :status => :unprocessable_entity }
        end
      end
    end

  end

  def update

    @note = Note.find(:first, :conditions => ["id = ? AND created_by = ?", params[:id], @current_user.id])

    whitelist = params[:note].slice(:title, :description)

    respond_to do |format|
      if @note.update_attributes(whitelist)
        format.json {render :locals => {note: @note}, :template => "notes/show", :formats => [:json], :handlers => [:jbuilder]}
      else
        format.html { render :action => "edit" }
        format.json { render :json => @note.errors, :status => :unprocessable_entity }
      end
    end

  end

  def destroy
    @note = Note.find(:first, :conditions => ["id = ? AND created_by = ?", params[:id], @current_user.id])
    if @note && @note.destroy()
      render :json => :true, :status => :ok
    else
      render :json => ["Not authorized to delete"], :status => :unprocessable_entity
    end
  end
end
