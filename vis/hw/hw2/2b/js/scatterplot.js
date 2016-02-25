function scatterplot(data){
// Set up ahead of drawing plot ---------------------------------------------------------------
// Create helper variables to save some typing 
var xVar = "Appearances",
	yVar = "Medals";

// Set up force layout 
var force = d3.layout.force()
			.nodes(data)
			.size([width, height])
			.on("tick", tick)
			.charge(-10)
			.gravity(0)
			.chargeDistance(20);

// Set up x and y domains 
x.domain([0, d3.max(data, function(d) { return d.Appearances; })]).nice();
y.domain([0, d3.max(data, function(d) { return d.Medals; })]).nice;

// Set data values 
data.forEach(function(d) {
	d.x = x(d[xVar]);
	d.y = y(d[yVar]);
	d.color = color(d.Gender);
	d.radius = radius;
})		

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

// Add nodes
var node = svg_scatter.selectAll(".dot")
			.data(data)
			.enter().append("circle")
				.attr("class", "dot")
				.attr("r", radius)
				.attr("cx", function(d) { return x(d[xVar]); })
				.attr("cy", function(d) { return y(d[yVar]); })
				.style("fill", function(d) { return d.color; })
				.style("opacity", .75)
				.on("mouseover", tip2.show)
	      		.on("mouseout", tip2.hide);

// Add legend -----------------------------------------------------------------------------
// Set up legend object
var legend = svg_scatter.selectAll(".legend")
			  .data(color.domain())
				.enter().append("g")
			  .attr("class", "legend")
			  .attr("transform", function(d, i) { return "translate(0," + i * 20 + ")"; });

// Add colour boxes
		legend.append("rect")
		  .attr("x", width - 18)
		  .attr("width", 18)
		  .attr("height", 18)
		  .style("fill", color);

// Add class labels
		legend.append("text")
		  .attr("x", width - 24)
		  .attr("y", 9)
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