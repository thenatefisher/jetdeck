json.(@action,
    :id,
    :title,
    :description,
    :due_at,
    :is_completed,
    :completed_at,
    :actionable_type,
    :url)
    
json.list_due_at @action.due_at.strftime("%b %d, %Y") if @action.due_at
json.list_title @action.title.truncate(35) if @action.title
json.past_due (@action.due_at < Time.now()) if @action.due_at

