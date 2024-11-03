// File app/assets/javascripts/portfolio_chart.js

function drawChart(chartData, currencyID) {
    // Prepare the data
    var data = new google.visualization.DataTable();
    data.addColumn('datetime', 'Date');
    ids = [];
    chartData.symbols.forEach(symbol => {
        if (document.getElementById(`checkbox-${currencyID}-${symbol.id}`).checked) {
            data.addColumn('number', symbol.alias);
            ids.push(symbol.id);
        }
    })
    // data.addColumn({ type: 'string', role: 'tooltip', p: { html: true } });

    for (var date in chartData.symbols_history) {
        var row = [new Date(date)];
        total = 0;
        for (var i = 0; i < ids.length; i++) {
            var value = chartData.symbols_history[date][ids[i]] || 0;
            row.push(value);
            total += value;
        }
        // row.push(createCustomTooltip(date, value, total, currencyID));
        data.addRow(row);
    }

    var formatter = new google.visualization.NumberFormat({
        pattern: '€#,###' // TODO: implement it properly
    });
    for (var i = 0; i < ids.length; i++) {
        formatter.format(data, i + 1);
    }

    // Set chart options
    var options = {
        title: 'Portfolio',
        hAxis: {
            format: 'MMM/yyyy',
            gridlines: {
                color: 'transparent'
            }
        },
        vAxis: {
            format: 'currency',
            gridlines: {
                color: 'transparent'
            },
            format: '€#,###' // TODO: implement it properly
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

function toggleColumn() {
    console.log("To be implemented");
    // drawChart(chartData, currencyID) ;
}

// function createCustomTooltip(date, value, total, currencyID) {
//     return `<div style="padding:5px;">
//                 <strong>Date: ${new Date(date).toLocaleDateString()}</strong><br>
//                 Value: ${value.toFixed(2)} ${currencyID}<br>
//                 Total: ${total.toFixed(2)} ${currencyID}
//             </div>`;
// }
