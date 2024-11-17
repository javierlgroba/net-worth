// File app/assets/javascripts/portfolio_chart.js

function drawChart(chartData, currencyID, currencyPrefix, currencyGroupingSymbol, currencyDecimalSymbol, currencySuffix) {
    // Prepare the data
    var data = new google.visualization.DataTable();
    data.addColumn('datetime', 'Date');
    ids = [];
    chartData.symbols.forEach(symbol => {
        data.addColumn('number', symbol.alias);
        ids.push(symbol.id);
    })

    for (var date in chartData.symbols_history) {
        var row = [new Date(date)];
        for (var i = 0; i < ids.length; i++) {
            var value = chartData.symbols_history[date][ids[i]] || 0;
            row.push(value);
        }
        data.addRow(row);
    }

    var formatter = new google.visualization.NumberFormat({
        prefix: currencyPrefix,
        groupingSymbol: currencyGroupingSymbol,
        decimalSymbol: currencyDecimalSymbol,
        suffix: currencySuffix
    });
    for (var i = 0; i < ids.length; i++) {
        formatter.format(data, i + 1);
    }

    // Set chart options
    var options = {
        title: `${currencyID.toUpperCase()} Portfolio`,
        hAxis: {
            format: 'MMM/yyyy',
            gridlines: {
                color: 'transparent'
            }
        },
        vAxis: {
            gridlines: {
                color: 'transparent'
            },
            format: formatter
        },
        legend: 'none',
        areaOpacity: 0.4,
        colors: ['#009846', '#FF5733', '#FFC300', '#DAF7A6', '#C70039', '#900C3F', '#581845', '#1F618D'],
        tooltip: {
            isHtml: true
        },
        backgroundColor: 'transparent',
        animation: {
            startup: true,
            duration: 1000,
            easing: 'inAndOut'
        },
        isStacked: 'true'
    };

    // Instantiate and draw the chart
    var chart = new google.visualization.AreaChart(document.getElementById(`chart_div_${currencyID}`));
    chart.draw(data, options);
}
