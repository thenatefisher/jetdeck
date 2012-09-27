class SearchController < ApplicationController
  before_filter :authorize

  # GET /search
  def navbar

    if params[:term].present?
    
        limit = params[:limit] || 10
        each_kind_limit = (limit/2).to_i
    
        @results = Array.new()
        
        @airframe_results = Airframe.find(:all,
        :conditions => [  "upper(registration) like ? 
                           OR upper(serial) like ?
                           AND user_id = ?",
                          "%"+params[:term].to_s.upcase+"%",
                          "%"+params[:term].to_s.upcase+"%",
                          @current_user.id],
        :select => "DISTINCT ON (id) id, *"
        ).first(each_kind_limit).each {|a| @results << a}

        slots_avail = each_kind_limit - @airframe_results.count

        @contact_results = Contact.find(:all,
        :conditions => [  "upper(first || ' ' || last) like ? 
                           AND owner_id = ?",
                          "%"+params[:term].to_s.upcase+"%",
                          @current_user.id],
        :select => "DISTINCT ON (id) id, *"
        ).first(each_kind_limit+slots_avail).each {|a| @results << a} 

        if @results.empty?
            render :layout => false, :nothing => true
        else
            render :locals => { results: @results }, :template => "search/navbar", :handlers => [:jbuilder], :formats => [:json]
        end
    end

  end

end
