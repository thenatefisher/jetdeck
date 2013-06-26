this.convert_time = (date_string) ->
    parsed_date = new Date(Date.parse(date_string))
    date_string = parsed_date.getUTCMonth() + '/'
    date_string += parsed_date.getUTCDate() + '/'
    date_string += parsed_date.getUTCFullYear() + ' '
    date_string += parsed_date.getUTCHours() + ':'
    date_string += if (parsed_date.getUTCMinutes() < 10) then '0' else ''
    date_string += parsed_date.getUTCMinutes()
    return date_string
