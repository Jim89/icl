/**
Generate a bar plot
**/
function barplot(data, athlete_selection) {

// Set up x and y domains
x_bar.domain([0, d3.max(data, function(d) { return d.Medals; })]);
y_bar.domain(data.map(function(d) { return d.Athlete; }));

// Set colous labels
data.forEach(function(d) {
  d.color_bar = color(d.Gender);
});

// Add X axis
  svg.append("g")
        .attr("class", "x axis")
        .call(xAxis_bar)
      .selectAll("text")
        .attr("y", -5)
        .attr("x", -3)
        .attr("dy", "-.55em")
        .style("text-anchor", "start");

// Add Y axis
  svg.append("g")
      .attr("class", "y axis")
      .call(yAxis_bar);

// Add x-axis label
  svg.append("text")
    .attr("class", "xlab")
    .attr("text-anchor", "right")
    .attr("y", 10)
    .attr("x", width - 65)
    .text("Total Medals");
  
  
// Bind data to bars 
var bars = svg.selectAll(".bar")
          .data(data);

// Enter phase
    bars.enter().append("rect");

// Update phase, set x, y, width, height
    bars.attr("class", "bar")
        .attr("x", 0)
        .attr("width", function(d) { return x_bar(d.Medals)})
        .attr("y", function(d) { return y_bar(d.Athlete); })
        .attr("height", y_bar.rangeBand())
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

} 


