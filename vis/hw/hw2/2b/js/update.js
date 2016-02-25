function update(athlete_selection) {
	// Group the data set by the athletes using d3.nest()
	var byAthlete = d3.nest()
					.key(function(d) { return d.Athlete; })
					.entries(rawData);

	// Convert entries to common format
	byAthlete = byAthlete.map(function(d) {
		return {
			Athlete: d.key,
			Medals: +d.Medals,
			Appearances: +d.Appearances 
		};
	});

	// Update the barplot
	barplot(rawData, athlete_selection);

	// Update the scatter
	scatterplot(rawData, athlete_selection);
}