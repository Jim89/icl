/**
Generate a bar plot
**/
function barplot(data) {

// Set up x and y domains
x_bar.domain([0, d3.max(data, function(d) { return d.Medals; })]);
y_bar.domain(data.map(function(d) { return d.Athlete; }));

// Set colous labels
data.forEach(function(d) {
  d.color_bar = color(d.Gender);
})  

// Add X axis
  svg.append("g")
        .attr("class", "x axis")
        .call(xAxis_bar)
      .selectAll("text")
        .attr("y", -5)
        .attr("x", -3)
        .attr("dy", "-.55em")
        .style("text-anchor", "start")

// Add Y axis
  svg.append("g")
      .attr("class", "y axis")
      .call(yAxis_bar)

// Add x-axis label
  svg.append("text")
    .attr("class", "xlab")
    .attr("text-anchor", "right")
    .attr("y", 10)
    .attr("x", width - 65)
    .text("Total Medals")
  
  
// Add the bars (i.e. the data!)
  svg.selectAll(".bar")
      .data(data)
    .enter().append("rect")
      .attr("class", "bar")
      .attr("x", 0)
      .attr("width", function(d) { return x_bar(d.Medals)})
      .attr("y", function(d) { return y_bar(d.Athlete); })
      .attr("height", y_bar.rangeBand())
      .style("fill", function(d) { return d.color_bar; })
      .on("mouseover", tip.show)
      .on("mouseout", tip.hide);  

// Add legend
var legend = svg.selectAll(".legend")
        .data(color.domain())
      .enter().append("g")
        .attr("class", "legend")
        .attr("transform", function(d, i) { return "translate(0," + i * 20 + ")"; });

legend.append("rect")
  .attr("x", width - 18)
  .attr("y", height - 100)  
  .attr("width", 18)
  .attr("height", 18)
  .style("fill", color);

legend.append("text")
  .attr("x", width - 24)
  .attr("y", height - 90)
  .attr("dy", ".35em")
  .style("text-anchor", "end")
  .text(function(d) { return d; });           

  
} 


