require ['bootstrap', 'jquery', 'd3', 'd3.promise', 'e2d3', 'markdown'], (bootstrap, $, d3, d3Promise, e2d3, markdown) ->
  debugCounter = 5

  $(window).on 'keydown', (e) ->
    if e.ctrlKey && e.keyCode == 17
      if --debugCounter == 0
        $('#delegate').show()
    else
      debugCounter = 5

  if e2d3.util.isDelegateMode()
    $('#delegate a').html('<i class="fa fa-sign-out"></i> Leave from delegate mode')
    $('#delegate').show()

  $('#delegate').on 'click', (e) ->
    e2d3.util.setDelegateMode !e2d3.util.isDelegateMode()
    window.location.reload()

  Promise.all [d3.promise.html('cell.html'), e2d3.api.topcharts()]
    .then (values) ->
      cell = values[0]
      charts = values[1]

      figures = d3.select '#contrib'
        .selectAll 'div'
          .data charts
        .enter().append 'div'
          .classed 'col-xs-4', true
          .each (d, i) ->
            newcell = d3.select(cell.cloneNode(true))

            newcell.select '.cover'
              .style 'background-image', "url('#{d.baseUrl}/thumbnail.png')"
              .select '.title'
              .text d.title

            newcell.select '.readme'
              .each ->
                d3.text d.baseUrl + '/README.md', (error, readme) =>
                  this.innerHTML = markdown.toHTML readme, 'Maruku'

            newcell.select '.use'
              .attr 'href', "chart.html##{d.baseUrl},#{d.scriptType},#{d.dataType}"

            this.appendChild(newcell.node())

      undefined # cofeescript promise idiom
    .catch (err) ->
      e2d3.onError err
