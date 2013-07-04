this.parseDate = (input) ->
  date_parts = input.split('-')
  date = date_parts[2].substr(0,2)
  time = date_parts[2].substr(3,8)
  time_parts = time.split(':')
  return new Date(date_parts[0], date_parts[1], date, time_parts[0], time_parts[1], time_parts[2])

this.convert_time = (date_string) ->
    parsed_date = parseDate(date_string)
    date_string = parsed_date.getUTCMonth() + '/'
    date_string += parsed_date.getUTCDate() + '/'
    date_string += parsed_date.getUTCFullYear() + ' '
    date_string += parsed_date.getUTCHours() + ':'
    date_string += if (parsed_date.getUTCMinutes() < 10) then '0' else ''
    date_string += parsed_date.getUTCMinutes()
    return date_string
