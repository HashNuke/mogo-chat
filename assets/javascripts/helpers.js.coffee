Em.Handlebars.helper 'readable-time', (value, options)->
  time = moment(value)
  difference = moment().unix() - time.unix()
  if difference > 31536000
    time.format("h:mma, D MMM YYYY")
  else
    time.format("h:mma, D MMM")
