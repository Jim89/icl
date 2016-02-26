function update(athlete_selection, grid = true) {
	
	// Update the barplot
	barplot(rawData, athlete_selection, grid);

	// Update the scatter
	scatterplot(rawData, athlete_selection, grid);
}