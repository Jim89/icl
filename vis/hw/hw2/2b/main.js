// Step 0 - Create variables ----------------------------------------------------------------
//create a D3 time formatter for converting the result dates into pretty strings
var result_formatter = d3.time.format.utc('%H:%M:%S.%L');

var width = 420,
    barHeight = 20;

var x = d3.scale.linear()
    .range([0, width]);

var chart = d3.select(".chart")
    .attr("width", width);

var table1 = d3.select('body').append('table');
table1.append('caption').text('Dataset1');
table1.append('thead').append('tr');
table1.append('tbody');    

// Step 1 - Create functions ----------------------------------------------------------------
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

/**
Generate a bar plot
**/
function barplot(data) {
  x.domain([0, d3.max(data, function(d) { return d.values; })]);

  chart.attr("height", barHeight * data.length);

  var bar = chart.selectAll("g")
      .data(data)
    .enter().append("g")
      .attr("transform", function(d, i) { return "translate(0," + i * barHeight + ")"; });

  bar.append("rect")
      .attr("width", function(d) { return x(d.values); })
      .attr("height", barHeight - 1);

  bar.append("text")
      .attr("x", function(d) { return x(d.values) - 3; })
      .attr("y", barHeight / 2)
      .attr("dy", ".35em")
      .text(function(d) { return d.values; });
}    

// Step 2 - read in external data ----------------------------------------------------
d3.tsv('./data/MedalData1.csv', function(metaldata1) {
  //data wrangling of the dataset    
  metaldata1.forEach(function(d) {
    //convert Games column to number
    d.Games = parseInt(d.Games);  
    //convert the column ResultsInSeconds to a date
    d.Result = d.ResultInSeconds === 'No result' ? null : new Date(parseFloat(d.ResultInSeconds)*1000);
    //and delete the original column  
    delete d.ResultInSeconds;
    // Clean athlete name
    d.Athlete = d.Athlete.toLowerCase()
  });
    
  //use just a subset of the first 10 rows (0 ... start index, 10 length)
  var subset = metaldata1.slice(0,10);

  var rolled_up = d3.nest()
                .key(function(d) { return d.Athlete })
                .rollup(function(leaves) { return leaves.length; })
                .entries(metaldata1);
    
  //render the subset    
  updateTable(table1, rolled_up);

  // render barplot
  barplot(rolled_up);
});

