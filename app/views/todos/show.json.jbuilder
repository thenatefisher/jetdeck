json.(@action,
    :id,
    :title,
    :description,
    :is_completed,
    :created_at,
    :actionable_type,
    :url)
    
json.due_at @action.due_at.localtime if @action.due_at
json.completed_at @action.completed_at.localtime if @action.completed_at  
json.parent_name @action.actionable.to_s  
json.list_due_at @action.due_at.localtime.strftime("%b %d, %Y") if @action.due_at
json.list_title @action.title.truncate(35) if @action.title
json.past_due (@action.due_at < Time.now()) if @action.due_at


