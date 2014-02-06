class window.MogoPaintBox
  nextColor: 0
  colors: [
    "E35D5C"
    "829DE7"
    "77B546"
    "FFCC20"
    "A79D95"
    "809DAA"
    "9013FE"
    "637AB2"
    "BBAD7C"
    "C831DD"
    "71CCD3"
    "417505"
  ]

  getColor: ->
    color = @colors[@nextColor]
    @nextColor = @nextColor + 1
    if @nextColor >= @colors.length
      @nextColor = 0
    "##{color}"
