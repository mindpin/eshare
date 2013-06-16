# 课程
jQuery ->
  $chart = jQuery('.page-chart.course-ware.read-count-last-week')
  return false if $chart.length == 0

  jQuery.ajax
    url: $chart.data('url')
    success: (res)->
      dates = jQuery.map res, (x)->
        x.date.split('-')[1..2].join('-')

      changes = jQuery.map res, (x)->
        x.change

      values = jQuery.map res, (x)->
        x.value

      chart_option = 
        chart:
          type: 'column'
          margin: [20, 50, 50, 60]
        title:
          text: null
        xAxis:
          categories: dates
          labels:
            rotation: -45
            align: 'right'
            style: 
              fontSize: '10px'
        yAxis:
          min: 0
          title:
            text: '学习进度'
            style: 
              fontSize: '12px'
              fontWeight: 'normal'
        legend:
          enabled: false
        series: [
          {
            animation: false
            name: '本日新增进度'
            data: changes
            dataLabels:
              enabled: true
              rotation: 0
              color: '#FFFFFF'
              align: 'center'
              x: 0
              y: 30
              style:
                fontSize: '12px'
          },
          {
            animation: false
            name: '总进度'
            data: values
            type: 'spline'
            dataLabels:
              enabled: true
              rotation: 0
              color: '#000'
              align: 'right'
              x: 0
              y: 0
              style:
                fontSize: '12px'
          }
        ]

      $chart.highcharts chart_option

jQuery ->
  jQuery('.page-chart.chapter-read-pie').each ->
    $chart = jQuery(this)

    jQuery.ajax
      url: $chart.data('url')
      success: (res)->
        none    = res.none
        read    = res.read
        reading = res.reading
        
        option =
          chart:
            plotBackgroundColor: null
            plotBorderWidth: null
            plotShadow: false
            backgroundColor: null

          title:
            text: null

          plotOptions: 
            pie: 
              allowPointSelect: false
              # cursor: 'pointer'

          series: [
            {
              type: 'pie'
              name: '课件数'
              animation: false
              innerSize: '60%'
              dataLabels:
                formatter: ->
                  if @y > 0 then @y else null
                color: 'white'
                distance: -25
                style:
                  fontSize: '15px'
                  fontWeight: 'bold'
              data: [
                {
                  name: '已完成学习'
                  y: read
                  color: '#00AA00'
                },

                {
                  name: '未学习'
                  y: none
                  color: '#CDCDCD'
                },

                {
                  name: '正在学习'
                  y: reading
                  color: '#80CC00'
                },
              ]
            }
          ]

        $chart.highcharts option

jQuery ->
  jQuery('.page-chart.all-course-read-pie').each ->
    $chart = jQuery(this)

    jQuery.ajax
      url: $chart.data('url')
      success: (res)->
        none    = res.none
        read    = res.read
        reading = res.reading
        
        option =
          chart:
            backgroundColor: null
            plotBackgroundColor: null
            plotBorderWidth: null
            plotShadow: false

          title:
            text: null

          plotOptions: 
            pie: 
              allowPointSelect: false
              # cursor: 'pointer'

          series: [
            {
              type: 'pie'
              name: '课程数'
              animation: false
              innerSize: '60%'
              dataLabels:
                formatter: ->
                  if @y > 0 then @y else null
                color: 'white'
                distance: -25
                style:
                  fontSize: '15px'
                  fontWeight: 'bold'
              data: [
                {
                  name: '已完成学习'
                  y: read
                  color: '#00AA00'
                },

                {
                  name: '未学习'
                  y: none
                  color: '#CDCDCD'
                },

                {
                  name: '正在学习'
                  y: reading
                  color: '#80CC00'
                },
              ]
            }
          ]

        $chart.highcharts option

jQuery('.page-chart.all-courses-punch-card').each ->
    $chart = jQuery(this)
    jQuery.ajax
      url: $chart.data('url')
      success: (res)->
        $chart.html res

jQuery ->
  jQuery('.page-chart.survey-single-choice-stat').each ->
    $chart = jQuery(this)
    data = []
    $chart.parent().find('.options .option').each ->
      $option = jQuery(this)
      data.push {
        name: $option.data('o'), 
        y: $option.data('c')
      }

    option =
      chart:
        plotBackgroundColor: null
        plotBorderWidth: null
        plotShadow: false
        backgroundColor: null

      title:
        text: null

      plotOptions: 
        pie: 
          allowPointSelect: false
          # cursor: 'pointer'

      series: [
        {
          type: 'pie'
          name: '课件数'
          animation: false
          # innerSize: '20%'
          dataLabels:
            formatter: ->
              if @y > 0 then @y else null
            color: 'white'
            distance: -25
            style:
              fontSize: '12px'
              fontWeight: 'bold'
          data: data
        }
      ]
    console.log $chart, $chart.highcharts
    $chart.highcharts option