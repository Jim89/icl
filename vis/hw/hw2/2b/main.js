// Step 0 - Set up environment ---------------------------------------------------------
// Set up overall SVG element
var margin = {top: 40, right: 20, bottom: 10, left: 150},
	width = 750 - margin.left - margin.right,
    height = 750 - margin.top - margin.bottom;
    padding = 1;
    radius = 7.5;


var svg = d3.select("body").append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")"); 

var svg_scatter = d3.select("body").append("svg")
		.attr("id", "svg_scatter")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");         
      
// Set up variables for barplot
var x_bar = d3.scale.linear()
        .range([0, width]);

var y_bar = d3.scale.ordinal()
        .rangeRoundBands([0, height], .2);

var xAxis_bar = d3.svg.axis()
            .scale(x_bar)
            .orient("top");

var yAxis_bar = d3.svg.axis()
            .scale(y_bar)
            .tickSize(0, 0)
            .orient("left");

var tip = d3.tip()
          .attr('class', 'd3-tip')
          .offset([-10, 0])
          .html(function(d) {
            return "<span>" + d.Sport + "</span><br><span>" + d.CountryName + "</span>";
          })              
svg.call(tip);


// Set up variables for scatterplot
var x = d3.scale.linear()
                .range([0, width]);

var y = d3.scale.linear()
                .range([height, 0]);

var color = d3.scale.ordinal().range(["#1f77b4", "#800080"]);                

var xAxis = d3.svg.axis()
                    .scale(x)
                    .orient("bottom");

var yAxis = d3.svg.axis()
                    .scale(y)                    
                    .orient("left");


// add tooltip for scatterplot
var tip2 = d3.tip()
          .attr('class', 'd3-tip')
          .offset([-10, 0])
          .html(function(d) {
            return "<span>" + d.Athlete + "</span><br><span>" + d.Sport + "</span><br><span>" + d.CountryName + "</span>";
          })              
svg_scatter.call(tip2);


// Add controls
var controls = d3.select("body").append("label")
				.attr("id", "controls");
var checkbox = controls.append("input")
				.attr("id", "collisiondetection")		
				.attr("type", "checkbox");
		controls.append("span")
			.text("Collision detection")

/*
var table1 = d3.select('body').append('table');
			table1.append('caption').text('Dataset1');
			table1.append('thead').append('tr');
			table1.append('tbody');  
*/

// Step 1 - read in external data ----------------------------------------------------
d3.tsv("./data/data1_summary.csv", function(error, metaldata1) {
  metaldata1.forEach(function(d){
    d.Athlete = d.Athlete.toProperCase();
    d.Medals = +d.Medals;
    d.Appearances = +d.Appearances
  });
  // Filter - just take athletes with >= 4 medals             
  var filtered = metaldata1.filter(function(d) { return d.Medals >= 4; });

  // Sort the data such that the chart looks nicer
  /*
  var filtered_ordered = filtered.sort(function(a, b){ 
                                        if (a.Medals > b.Medals) {return -1;}
                                        else if (a.Medals < b.Medals) {return 1;}
                                        else return 0;});
	*/                                        

  // render barplot
  barplot(filtered);              
    
  //render the subset    
  // updateTable(table1, filtered_ordered);

  // render scatterplot
  scatterplot(filtered)

});



