function scatterplot(data){
	x_scatter.domain([0, d3.max(data, function(d) { return d.Appearances; })]).nice();
	y_scatter.domain([0, d3.max(data, function(d) { return d.Medals; })]).nice;

// Add X-axis and label
svg2.append("g")
	.attr("class", "x axis")
	.attr("transform", "translate(0," + height + ")")
	.call(xAxisScatter)
	.append("text")
		.attr("class", "label")
		.attr("x", width)
		.attr("y", -6)
		.style("text-anchor", "end")
		.text("Appearances")

// Add Y-axis and label
svg2.append("g")
	.attr("class", "y axis")
	.call(yAxisScatter)
	.append("text")
      .attr("class", "label")
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("Medals")

// Add dots
svg2.selectAll(".dot")
	.data(data)
	.enter().append("circle")
		.attr("class", "dot")
		.attr("r", 5)
		.attr("cx", function(d) { return x_scatter(d.Appearances); })
		.attr("cy", function(d) { return y_scatter(d.Medals); })
		.style("fill", "steelblue")
		.style("opacity", .75)
		.on("mouseover", tip2.show)
      	.on("mouseout", tip2.hide); 

}