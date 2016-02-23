//create a D3 time formatter for converting the result dates into pretty strings
var result_formatter = d3.time.format.utc('%H:%M:%S.%L');

/**
 * generates or update the table visualization
 * @param table the table DOM element
 * @param data the dataset to visualize
 */
function updateTable(table, data) {
  //each row is a key value dictionary, use the keys used in the first row determining the column names
  var data_columns = Object.keys(data[0]);

  //use d3 to create the th entries    
  var columns = table.select('thead tr').selectAll('th').data(data_columns);
  columns.enter().append('th');
  //the text is the value itself    
  columns.text(function(d) { return d; });
  columns.exit().remove();

  var rows = table.select('tbody').selectAll('tr').data(data);
  rows.enter().append('tr');
  //perform a nested selection for creating the columns for each row   
  var cols = rows.selectAll('td').data(function(row) {
      //compute the columns for each row by using the known column names computed before   
      //e.g. { a: 5, b: 'H' } will be [ 5, 'H'] assuming data_columns = ['a', 'b']
      return data_columns.map(function(d) { 
          return row[d]; 
      });
  });
  cols.enter().append('td');
  cols.text(function(d) {
    if (d instanceof Date) { //if the value is a Date use our formatter
      return result_formatter(d);
    } else {
      return d;
    };
  });
  cols.exit().remove();
  rows.exit().remove();  
}



//append a table to the body with a common base structure
var table1 = d3.select('body').append('table');
              table1.append('caption').text('Dataset1');
              table1.append('thead').append('tr');
              table1.append('tbody');

// append svg to body with common base structure
var margin = {top: 20, right: 20, bottom: 30, left: 40},
    width = 960 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

var x = d3.scale.ordinal()
  .rangeRoundBands([0, width], .1);

var y = d3.scale.linear()
  .range([height, 0]);

var xAxis = d3.svg.axis()
  .scale(x)
  .orient("bottom");

var yAxis = d3.svg.axis()
  .scale(y)
  .orient("left")
  .ticks(10, "%");

var svg = d3.select("body").append("svg")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom)
  .append("g")
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")");              

//external data
d3.csv('./data/data1.csv', function(data1) {
  //data wrangling of the dataset    

    
  //use just a subset of the first 10 rows (0 ... start index, 10 length)
  var subset = data1.slice(0,10);
    
  //render the subset in the table
  updateTable(table1, data1);


x.domain(data.map(function(d) { return d.letter; }));
  y.domain([0, d3.max(data, function(d) { return d.frequency; })]);

  svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis);

  svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)
    .append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("Frequency");

  svg.selectAll(".bar")
      .data(data)
    .enter().append("rect")
      .attr("class", "bar")
      .attr("x", function(d) { return x(d.letter); })
      .attr("width", x.rangeBand())
      .attr("y", function(d) { return y(d.frequency); })
      .attr("height", function(d) { return height - y(d.frequency); });
});

  


