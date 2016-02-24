// Step 0 - Set up environment ---------------------------------------------------------
var result_formatter = d3.time.format.utc('%H:%M:%S.%L');

var margin = {top: 20, right: 20, bottom: 10, left: 150},
    width = 960 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

/*
var x = d3.scale.ordinal()
        .rangeRoundBands([0, width], .15);

var y = d3.scale.linear()
    .range([height, 0]);

var xAxis = d3.svg.axis()
    .scale(x)
    .tickSize(0, 0)
    .orient("bottom");

var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left")  
*/


var x = d3.scale.linear()
        .range([0, width]);

var y = d3.scale.ordinal()
        .rangeRoundBands([0, height], .5);

var xAxis = d3.svg.axis()
            .scale(x)
            .orient("top");

var yAxis = d3.svg.axis()
            .scale(y)
            .tickSize(0, 0)
            .orient("left");

var svg = d3.select("body").append("svg")
            .attr("width", width + margin.left + margin.right)
            .attr("height", height + margin.top + margin.bottom)
            .append("g")
            .attr("transform", "translate(" + margin.left + "," + margin.top + ")"); 

/*
var table1 = d3.select('body').append('table');
			table1.append('caption').text('Dataset1');
			table1.append('thead').append('tr');
			table1.append('tbody');  
*/

// Step 1 - read in external data ----------------------------------------------------
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
    d.Athlete = d.Athlete.toLowerCase();
    d.Athlete = d.Athlete.toProperCase();
    d.Team = d.Athlete.indexOf(",");
  });

  var subset = metaldata1.slice(0, 10);

  var rolled_up = d3.nest()
                .key(function(d) { return d.Athlete; })
				.sortKeys(d3.ascending)                
                .rollup(function(leaves) { return leaves.length; })
                .entries(metaldata1);

             

  var filtered = rolled_up.filter(function(d) { return d.values >= 4; });

  // render barplot
  barplot(filtered);              
    
  //render the subset    
  //updateTable(table1, subset);

});

function type(d) {
  d.values = +d.values;
  return d;
}

