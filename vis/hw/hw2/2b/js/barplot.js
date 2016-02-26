/**
Generate a bar plot
**/
function barplot(data, athlete_selection) {

// Set up x and y domains
x_bar.domain([0, d3.max(data, function(d) { return d.Medals; })]);
y_bar.domain(data.map(function(d) { return d.Athlete; }));

// Set colous labels based on gender
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

// Add X grid
svg.append("g")         
        .attr("class", "grid_bar")
        .attr("transform", "translate(0," + height + ")")
        .call(make_x_axis_bar()
            .tickSize(-height, 0, 0)
            .tickFormat("")
        )     
  
  
// Bind data to bars 
var bars = svg.selectAll(".bar")
          .data(data);

// Enter phase
    bars.enter()
        .append("rect");

// Update phase, set x, y, width, height
    bars.attr("class", "bar")
        .attr("x", 0)
        .attr("width", function(d) { return x_bar(d.Medals)})
        .attr("y", function(d) { return y_bar(d.Athlete); })
        .attr("height", y_bar.rangeBand())
        .style("fill", function(d) { return d.color_bar; })
        .style("opacity", .75)

// Set up (empty) array of selected athletes
var athletes = [];
// Event phase - things to do on actions        
    bars.on("mouseover", tip.show)
        .on("mouseout", tip.hide)
        .on("click", function(d){
          // Select currently bound data element, i.e. the athlete
            new_athlete = d.Athlete;

          // Add the new athlete to the selection
            athletes.push(new_athlete);            

          // If CTRL key is held, add the selection to the list of athletes
            if (d3.event.ctrlKey) {
                // Get the clicked element
                var clicked = d.Athlete;

                // Add it to the list of athletes if it does not already contain it
                // N.B. contains is a custom function that returns true if the second parameter
                // exists as an element inside the first
                if (!contains(athletes, clicked)){
                  athletes.push(clicked);
                }
            }
            // Print out athletes array for debugging
            console.log(athletes);
            update(athletes);
            });
        

// Exit phase: remove remaining dom elements
    bars.exit().remove();

} 


