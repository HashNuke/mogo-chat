Em.Handlebars.helper 'relativeTime', (value, options)->
  time = moment(value)
  difference = moment().unix() - time.unix()
  if difference > 31536000
    time.format("MMM D, YYYY")
  else if difference > 86400
    time.format("MMM D")
  else
    time.fromNow(true)


Em.Handlebars.helper 'readableTime', (value, options)->
  time = moment(value)
  difference = moment().unix() - time.unix()
  if difference > 31536000
    time.format("MMM D, YYYY, h:mm a")
  else
    time.format("MMM D, h:mm a")
