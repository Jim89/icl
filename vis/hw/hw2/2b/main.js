// Set up overall SVG elements ----------------------------------------------------------
// Variables for SVG sizing
var margin = {top: 40, right: 20, bottom: 40, left: 160},
    width = 750 - margin.left - margin.right,
    height = 825 - margin.top - margin.bottom;
    padding = 1;
    radius = 7.5;

// SVG for barchart
var svg = d3.select("body").append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")"); 

// SVG for scatterplot
var svg_scatter = d3.select("body").append("svg")
		.attr("id", "svg_scatter")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

// Variable to enable colouring by gender
var color = d3.scale.ordinal().range(["#1f77b4", "#800080"]);                                 
      
// Set up variables for barplot -----------------------------------------------------------
// X scale
var x_bar = d3.scale.linear()
        .range([0, width]);

// Y scale
var y_bar = d3.scale.ordinal()
        .rangeRoundBands([0, height], .2);

// X axis
var xAxis_bar = d3.svg.axis()
            .scale(x_bar)
            .orient("top");

// Y axis
var yAxis_bar = d3.svg.axis()
            .scale(y_bar)
            .tickSize(0, 0)
            .orient("left");

// Tooltip
var tip = d3.tip()
          .attr('class', 'd3-tip')
          .offset([-10, 0])
          .html(function(d) {
            return "<span>" + d.Sport + "</span><br><span>" + d.CountryName + "</span>";
          })              
svg.call(tip);

// Functions for drawing grid lines
function make_x_axis_bar() {        
    return d3.svg.axis()
              .scale(x_bar)
               .orient("bottom")
               .ticks(13)
}


// Set up variables for scatterplot ----------------------------------------------------------
// X scale
var x = d3.scale.linear()
                .range([0, width]);

// Y scale
var y = d3.scale.linear()
                .range([height, 0]);

// X axis
var xAxis = d3.svg.axis()
                    .tickFormat(d3.format("d"))
                    .scale(x)
                    .orient("bottom");

// Y axis
var yAxis = d3.svg.axis()
                    .scale(y)                    
                    .orient("left");

// Tooltip
var tip2 = d3.tip()
          .attr('class', 'd3-tip')
          .offset([-10, 0])
          .html(function(d) {
            return "<span>" + d.Athlete + "</span><br><span>" + d.Sport + "</span><br><span>" + d.CountryName + "</span>";
          })              
svg_scatter.call(tip2);

// Control button for force-directed layout
var controls = d3.select("body").append("label")
				.attr("id", "controls");
var checkbox = controls.append("input")
				.attr("id", "collisiondetection")		
				.attr("type", "checkbox");
		controls.append("span")
			.text("Collision detection (separate dots slightly)")

// Functions for drawing grid lines
function make_x_axis() {        
    return d3.svg.axis()
              .scale(x)
               .orient("bottom")
               .ticks(5)
}

function make_y_axis() {        
    return d3.svg.axis()
        .scale(y)
        .orient("left")
        .ticks(13)
}


// Read in external data ----------------------------------------------------

// After loading the data asynchronously they are stored in this variable
var rawData;

// Read in data an make plots
d3.tsv("./data/data1_summary.csv", function(error, metaldata1) {
  metaldata1.forEach(function(d){
    d.Athlete = d.Athlete.toProperCase();
    d.Medals = +d.Medals;
    d.Appearances = +d.Appearances
  });
  // Filter - just take athletes with >= 4 medals             
  var filtered = metaldata1.filter(function(d) { return d.Medals >= 4; });

  // Sort the data such that the chart looks nicer

  var filtered_ordered = filtered.sort(function(a, b){ 
                                        if (a.Medals > b.Medals) {return -1;}
                                        else if (a.Medals < b.Medals) {return 1;}
                                        else return 0;});

  rawData = filtered_ordered;

  update(null);

});



