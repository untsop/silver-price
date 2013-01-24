jQuery ($) ->
  displayQuote = (data) ->
    current = data[2]
    change = data[3]
    changePercent = data[4]
    $("#current div.value #price").html current
    $("title").html "$#{current} - Silver Price"
    unless changePercent.indexOf("-") >= 0
      $(".change").addClass("up")
      $(".change").removeClass("down")
    else
      if changePercent is "0.00"
        $(".change").removeClass("down")
        $(".change").removeClass("up")
      else
        $(".change").addClass("down")
        $(".change").removeClass("up")

    $("#changeStock").html change
    $("#changePercent").html "#{changePercent}"

  getQuote = ->
    $.ajax
      url: "http://sp.hubuzhi.com/silverapi.php"
      success: (data) ->
        displayQuote data
        $('#current').addClass('show')
      error: ->
        $('#current').addClass('error')

      dataType: "json"

  getQuote()
  setInterval getQuote, 10000
  getChartData()

parsedGraphData = []

jsonpChartCallback = (data) ->
  parseData(data)
  drawVisualization()
  $("#loader").hide()
  $("#chart").show '100'

parseData = (data) ->
  parsedGraphData.push [ "x", "Silver Price" ]
  if data
    $.each data.columnValues , (k, quote) ->
      time = new Date(quote[0]);
      date = time.getFullYear() + "/" + (time.getMonth()+1) + "/" + time.getDate()
      # myfloat = parseFloat(quote[1]) / parseFloat(31.1035) * parseFloat(exports.rate)
      myfloat = parseFloat(quote[1])
      myfloat = parseFloat(myfloat.toFixed(4))
      parsedGraphData.push [date, myfloat]

getChartData = ->
  $.ajax
    url: "http://www.learcapital.com/charts/generated/silver_1month.json?callback=?"
    success: jsonpChartCallback
    dataType: "jsonp"

drawVisualization = ->
  data = google.visualization.arrayToDataTable(parsedGraphData)
  new google.visualization.LineChart(document.getElementById("chart")).draw data,
    curveType: "function"
    width: 740
    height: 200
    backgroundColor: "#666"
    pointSize: 9
    axisTitlesPosition: "none"
    lineWidth: 3
    colors: [ "#999" ]
    legend:
      position: "none"

    chartArea:
      width: "720"

    animation:
      duration: 1
      easing: "inAndOut"

    vAxis:
      gridlines:
        color: "#666"

      textPosition: "none"
      baselineColor: "none"

    hAxis:
      textPosition: "none"
google.load "visualization", "1",
packages: [ "corechart" ]