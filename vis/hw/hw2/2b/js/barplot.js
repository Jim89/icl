/**
Generate a bar plot
**/
function barplot(data) {
/*
// Set up x and y domains
  x.domain(data.map(function(d) { return d.key; }));
  y.domain([0, d3.max(data, function(d) { return d.values; })]);

// Add X axis
  svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis)
      .selectAll("text")
        .attr("y", 0)
        .attr("x", -150)
        .attr("dy", ".35em")
        .attr("transform", "rotate(-90)")
        .style("text-anchor", "start")

// Add Y axis
  svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)
    .append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("Total Medals");


// Add the bars (i.e. the data!)
  svg.selectAll(".bar")
      .data(data)
    .enter().append("rect")
      .attr("class", "bar")
      .attr("x", function(d) { return x(d.key); })
      .attr("width", x.rangeBand())
      .attr("y", function(d) { return y(d.values); })
      .attr("height", function(d) { return height - y(d.values); });
*/

// Set up x and y domains
x.domain([0, d3.max(data, function(d) { return d.Medals; })]);
y.domain(data.map(function(d) { return d.Athlete; }));


// Add X axis
  svg.append("g")
        .attr("class", "x axis")
        .call(xAxis)
      .selectAll("text")
        .attr("y", -2)
        .attr("x", -3)
        .attr("dy", "-.55em")
        .style("text-anchor", "start")

// Add Y axis
  svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)

// Add x-axis label
  svg.append("text")
    .attr("class", "xlab")
    .attr("text-anchor", "middle")
    .attr("y", -25)
    .attr("x", width/2)
    .text("Total Medals")
  
    

// Add the bars (i.e. the data!)
  svg.selectAll(".bar")
      .data(data)
    .enter().append("rect")
      .attr("class", "bar")
      .attr("x", 0)
      .attr("width", function(d) { return x(d.Medals)})
      .attr("y", function(d) { return y(d.Athlete); })
      .attr("height", y.rangeBand())
      .on("mouseover", tip.show)
      .on("mouseout", tip.hide);       
} 


