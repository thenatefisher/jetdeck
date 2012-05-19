  
class Backbone.CollectionBook extends Backbone.Collection
 
  constructor : (options) ->
    super()
 
    # set options (Should be private)
    @_page_size      = 9
   
    # state variables (Should be private)
    @_current_page   = 1
    @_offset         = 0
   
    return this
    
  currentPage : ->
    return @_current_page
  
  page : ->
    deliverable = []
    for i in [@_offset..(@_page_size + @_offset - 1)]
        deliverable.push(@at(i))
    return deliverable
  
  pages : ->
    return Math.ceil (@length / @_page_size)
   
  eachOnPage : (f) ->
    for i in [@_offset..(@_page_size + @_offset - 1)]   
        f(@at(i)) 
    return this
   
  turnTo : (p) ->
    if p > 0 && p <= @pages()
        @_offset = @_page_size * (p - 1)
        @_current_page = p
    return this
 
  next : ->
    if (@_offset + @_page_size) < @length
        @_offset += @_page_size
        @_current_page++
    return this
   
  prev : ->
    if @_offset >= @_page_size
        @_offset -= @_page_size
        @_current_page--
    return this
