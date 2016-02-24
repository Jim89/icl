/**
 * generates or update the table visualization
 * @param table the table DOM element
 * @param data the dataset to visualize
 */
function updateTable(table, data) {
  //each row is a key value dictionary, use the keys used in the first row determining the column names
  var data_columns = Object.keys(data[0]);

  //use d3 to create the th entries    
  var columns = table.select('thead tr').selectAll('th').data(data_columns);
  columns.enter().append('th');
  //the text is the value itself    
  columns.text(function(d) { return d; });
  columns.exit().remove();

  var rows = table.select('tbody').selectAll('tr').data(data);
  rows.enter().append('tr');
  //perform a nested selection for creating the columns for each row   
  var cols = rows.selectAll('td').data(function(row) {
      //compute the columns for each row by using the known column names computed before   
      //e.g. { a: 5, b: 'H' } will be [ 5, 'H'] assuming data_columns = ['a', 'b']
      return data_columns.map(function(d) { 
          return row[d]; 
      });
  });
  cols.enter().append('td');
  cols.text(function(d) {
    if (d instanceof Date) { //if the value is a Date use our formatter
      return result_formatter(d);
    } else {
      return d;
    };
  });
  cols.exit().remove();
  rows.exit().remove();  
}