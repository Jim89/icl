/*
// Set axis scale domains
xscaleBC.domain([0, d3.map(function(d) { return d.Medals; })]);
yscaleBC.domain(data.map(function(d) { return d.Athlete; }));



// Update x and y axes in the chart
svgBarChart.select("g.xaxis")
            .attr("class", "x axis")
            .call(xaxisBC)
            .selectAll("text")
            .attr("y", -5)
            .attr("x", -3)
            .attr("dy", "-.55em")
            .style("text-anchor", "start");


svgBarChart.select("g.yaxis").call(yaxisBC);

// Select the chart group in the svg as base and bind data to rect elements
var bars = svgBarChart.select("g.chart")
                      .selectAll("rect")
                      .data(data);

// Enter phase: append a new rect and register on-click handler
var bars_enter = bars.enter()
                      .append("rect")
                      .on("click", function(d) {
                        var selection = d.Athlete;
                        update(selection);
                      });

// Update phase, set x, y, width, height
    bars.attr("class", "bar")
        .attr("x", 0)
        .attr("width", function(d) { return xscaleBC(d.Medals)})
        .attr("y", function(d) { return yscaleBC(d.Athlete); })
        .attr("height", yscaleBC.rangeBand())
        .style("fill", function(d) { return d.color_bar; })
        .style("opacity", .75)
        .classed('selected', function(d) {
          // Add css class 'selected' if the entry is selected
          return d.Athlete === athlete_selection;
        });

// Event phase - things to do on actions        
    bars.on("mouseover", tip.show)
        .on("mouseout", tip.hide)
        .on("click", function(d){
          // Select currently bound data element, i.e. the athlete
          var athlete = d.Athlete;
          // Trigger to update visualisation
          update(selection);
        });

// Exit phase: remove remaining dom elements
    bars.exit().remove();
*/


// SVG element of barchart
var svgBarChart = d3.select("#barchart");

// d3 scales and axes for bar chart
var xscaleBC = d3.scale.linear().range([0, width]);
var yscaleBC = d3.scale.ordinal().rangeRoundBands([0, height], .2);

var xaxisBC = d3.svg.axis().scale(xscaleBC).orient("top");
var yaxisBC = d3.svg.axis().scale(yscaleBC).orient("left");