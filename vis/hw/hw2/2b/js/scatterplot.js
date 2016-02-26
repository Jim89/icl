function scatterplot(data, athlete_selection){
// Set up ahead of drawing plot ---------------------------------------------------------------
// Create helper variables to save some typing 
var xVar = "Appearances",
	yVar = "Medals";

// Set up force layout 
var force = d3.layout.force()
			.nodes(data)
			.size([width, height])
			.on("tick", tick)
			.charge(-5)
			.gravity(0)
			.chargeDistance(50);

// Set up x and y domains 
x.domain([0, d3.max(data, function(d) { return d.Appearances; })]).nice();
y.domain([0, d3.max(data, function(d) { return d.Medals; })]).nice();

// Set up grid lines
var line = d3.svg.line()
              .x(function(d) { return x(d.Appearances); })
              .y(function(d) { return y(d.Medals); });

// Set data values 
data.forEach(function(d) {
	d.x = x(d[xVar]);
	d.y = y(d[yVar]);
	d.color = color(d.Gender);
	d.radius = radius;
})		

// Set up filtering ----------------------------------------------------------------------------
var filteredData = rawData;
if (athlete_selection !== null) {
	// If there is an athlete selection then just include those data items
	filteredData = data.filter(function(d) {
		var present = contains(athlete_selection, d.Athlete);
		// console.log(present)
		if (present) { return d.Athlete; };
		// return d.Athlete === athlete_selection;
	});
}

// Create the plot -----------------------------------------------------------------------------
// Add X-axis and label
svg_scatter.append("g")
	.attr("class", "x axis")
	.attr("transform", "translate(0," + height + ")")
	.call(xAxis)
	.append("text")
		.attr("class", "xlab")
		.attr("x", width)
		.attr("y", -6)
		.style("text-anchor", "end")
		.text("Appearances")

// Add Y-axis and label
svg_scatter.append("g")
	.attr("class", "y axis")
	.call(yAxis)
	.append("text")
      .attr("class", "ylab")
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("Medals")

// Add X grid
svg_scatter.append("g")         
        .attr("class", "grid_scatter")
        .attr("transform", "translate(0," + height + ")")
        .call(make_x_axis()
            .tickSize(-height, 0, 0)
            .tickFormat("")
        ) 

// Add Y grid
svg_scatter.append("g")         
	.attr("class", "grid_scatter")
	.call(make_y_axis()
	    .tickSize(-width, 0, 0)
	    .tickFormat("")
	)        

// Map data to dots
var node = svg_scatter.selectAll(".dot")
			.data(filteredData);

// Enter phase: append new circles with set radii			
	node.enter().append("circle")
		.attr("r", radius);

// Update phase: set cx and cy according to scales and values
	node.attr("class", "dot")
		.attr("cx", function(d) { return x(d[xVar]); })
		.attr("cy", function(d) { return y(d[yVar]); })
		.style("fill", function(d) { return d.color; })
		.style("opacity", .75)
		.classed('selected', function(d){
			// Add css class "selected" if athletes match
			return d.Athlete === athlete_selection;
		});

// Event phase - things to do on actions  
	node.on("mouseover", tip2.show)
  		.on("mouseout", tip2.hide);

// Exit phase: remove
	node.exit().remove();  		

// Add legend -----------------------------------------------------------------------------
// Set up legend object
var legend = svg_scatter.selectAll(".legend")
			  .data(color.domain())
				.enter().append("g")
			  .attr("class", "legend")
			  .attr("transform", function(d, i) { return "translate(0," + i * 20 + ")"; });

// Add colour boxes
		legend.append("rect")
		  .attr("x", width - 25)
		  .attr("y", 12)
		  .attr("width", 18)
		  .attr("height", 18)
		  .style("fill", color);

// Add class labels
		legend.append("text")
		  .attr("x", width - 34)
		  .attr("y", 21)
		  .attr("dy", ".35em")
		  .style("text-anchor", "end")
		  .text(function(d) { return d; });


// Use the force -----------------------------------------------------------------------------
// Set default force layout
d3.select("#collisiondetection").on("change", function() {
	force.resume();
});

force.start();

// Set what happens when "collision detection" ticked
function tick(e) {
	node.each(moveTowardDataPosition(e.alpha));

	if (checkbox.node().checked) node.each(collide(e.alpha));

	node.attr("cx", function(d) { return d.x; })
		.attr("cy", function(d) { return d.y; });
}

function moveTowardDataPosition(alpha) {
	return function(d) {
		d.x += (x(d[xVar]) - d.x) * 0.1 * alpha;
		d.y += (y(d[yVar]) - d.y) * 0.1 * alpha;
	};
}

// Resolve collision between nodes
function collide(alpha) {
	var quadtree = d3.geom.quadtree(data);
	return function(d) {
		var r = d.radius + radius + padding,
			nx1 = d.x - r,
			nx2 = d.x + r,
			ny1 = d.y - r,
			ny2 = d.y + r;
		quadtree.visit(function(quad, x1, y1, x2, y2) {
			if (quad.point && (quad.point !== d)) {
				var x = d.x - quad.point.x,
					y = d.y - quad.point.y,
					l = Math.sqrt(x * x + y * y),
					r = d.radius + quad.point.radius + (d.color !== quad.point.color) * padding;
			if (l < r) {
				l = (l - r) / l * alpha;
				d.x -= x *= l;
				d.y -= y *= l;
				quad.point.x += x;
				quad.point.y += y;
			}
		}
		return x1 > nx1 || x2 < nx1 || y2 > ny2 || y2 < ny1;
		});			

	};
}

}