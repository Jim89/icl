// Step 0 - Set up environment ---------------------------------------------------------
// Set up overall SVG element
var margin = {top: 40, right: 20, bottom: 10, left: 150},
    width = 750 - margin.left - margin.right,
    height = 750 - margin.top - margin.bottom;

var svg = d3.select("body").append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")"); 

var svg2 = d3.select("body").append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");         
       
// Set up variables for barplot
var x = d3.scale.linear()
        .range([0, width]);

var y = d3.scale.ordinal()
        .rangeRoundBands([0, height], .2);

var xAxis = d3.svg.axis()
            .scale(x)
            .orient("top");

var yAxis = d3.svg.axis()
            .scale(y)
            .tickSize(0, 0)
            .orient("left");

var tip = d3.tip()
          .attr('class', 'd3-tip')
          .offset([-10, 0])
          .html(function(d) {
            return "<span>" + d.Gender + "</span><br><span>" + d.Sport + "</span><br><span>" + d.CountryName + "</span>";
          })              
svg.call(tip);

// Set up variables for scatterplot
var x_scatter = d3.scale.linear()
                .range([0, width]);

var y_scatter = d3.scale.linear()
                .range([height, 0]);

var xAxisScatter = d3.svg.axis()
                    .scale(x_scatter)
                    .orient("bottom");

var yAxisScatter = d3.svg.axis()
                    .scale(y_scatter)                    
                    .orient("left");

// add the tooltip area to the webpage
var tip2 = d3.tip()
          .attr('class', 'd3-tip')
          .offset([-10, 0])
          .html(function(d) {
            return "<span>" + d.Athlete + "</span>";
          })              
svg2.call(tip2);                  

/*
var table1 = d3.select('body').append('table');
			table1.append('caption').text('Dataset1');
			table1.append('thead').append('tr');
			table1.append('tbody');  
*/

// Step 1 - read in external data ----------------------------------------------------
/*
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
*/
d3.tsv("./data/data1_summary.csv", function(error, metaldata1) {
  metaldata1.forEach(function(d){
    d.Athlete = d.Athlete.toProperCase();
    d.Medals = +d.Medals;
    d.Appearances = +d.Appearances
  });

  // Roll-up: count of records (medals) per athlete
  /*
  var rolled_up = d3.nest()
                .key(function(d) { return d.Athlete; })
                .rollup(function(leaves) { return leaves.length; })
                .entries(metaldata1);
  */
  // Filter - just take athletes with >= 4 medals             
  var filtered = metaldata1.filter(function(d) { return d.CountryCode === 'USA' && d.Medals >= 3; });

  // Sort the data such that the chart looks nicer
  var filtered_ordered = filtered.sort(function(a, b){ 
                                        if (a.Medals > b.Medals) {return -1;}
                                        else if (a.Medals < b.Medals) {return 1;}
                                        else return 0;});

  // render barplot
  barplot(filtered_ordered);              
    
  //render the subset    
  // updateTable(table1, filtered_ordered);

  // render scatterplot
  scatterplot(filtered_ordered)

});



