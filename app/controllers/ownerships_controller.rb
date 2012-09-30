class OwnershipsController < ApplicationController
  before_filter :authorize
  

  def create

    whitelist = params[:ownership].slice(:assoc, :description, :contact_id)

    @ownership = Ownership.new(whitelist)
    @ownership.created_by = @current_user.id
    
    respond_to do |format|
      if @ownership.save
        format.json {render :locals => {ownership: @ownership}, :template => "ownerships/show", :formats => [:json], :handlers => [:jbuilder]}
      else
        format.html { render :action => "new" }
        format.json { render :json => @ownership.errors, :status => :unprocessable_entity }
      end
    end

  end  

  def update
  
    @contact = Contact.find(:first, :conditions => 
      ["id = ? AND owner_id = ?", params[:ownership][:contact_id], @current_user.id])
    @ownership = @contact.ownerships.where(:id => params[:id]).first

    whitelist = params[:note].slice(:assoc, :description)

    respond_to do |format|
      if @ownership.update_attributes(whitelist)
        format.json {render :locals => {ownership: @ownership}, :template => "ownerships/show", :formats => [:json], :handlers => [:jbuilder]}
      else
        format.html { render :action => "edit" }
        format.json { render :json => @ownership.errors, :status => :unprocessable_entity }
      end
    end
    
  end

  def destroy
  
    @ownership = Ownership.find(:first, :conditions => 
      ["id = ? AND created_by = ?", params[:id], @current_user.id])

    @ownership.destroy
    render :json => true
    
  end
end
