/**
 * Created by Samuel Gratzl on 11.02.2016.
 */

//create a D3 time formatter for converting the result dates into pretty strings
var result_formatter = d3.time.format.utc('%H:%M:%S.%L');

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



//append a table to the body with a common base structure
//<table>
//<caption>Dataset1</caption>
//<thead>
//   <tr><!--header--></tr>
//<thead>
//<tbody>
//  <!--rows-->
//</tbody>
//</table>
var table1 = d3.select('body').append('table');
table1.append('caption').text('Dataset1');
table1.append('thead').append('tr');
table1.append('tbody');

//external data
d3.tsv('./data/MedalData1.csv', function(metaldata1) {
  //data wrangling of the dataset    
  metaldata1.forEach(function(d) {
    //convert Games column to number
    d.Games = parseInt(d.Games);  
    //convert the column ResultsInSeconds to a date
    d.Result = d.ResultInSeconds === 'No result' ? null : new Date(parseFloat(d.ResultInSeconds)*1000);
    //and delete the original column  
    delete d.ResultInSeconds;
  });
    
  //use just a subset of the first 10 rows (0 ... start index, 10 length)
  var subset = metaldata1.slice(0,10);
    
  //render the subset    
  updateTable(table1, subset);
});

var table2 = d3.select('body').append('table');
table2.append('caption').text('Dataset2');
table2.append('thead').append('tr');
table2.append('tbody');

d3.tsv('./data/MedalData2.csv', function(metaldata2) {
  //data wrangling of the dataset    
  metaldata2.forEach(function(d) {
    //convert Edition column to number
    d.Edition = parseInt(d.Edition);  
  });
    
  //use just a subset where the Edition is 2008 and Gold medals and females only   
  subset2008 = metaldata2.filter(function(d) {
    return d.Edition === 2008 && d.Medal === 'Gold' && d.Event_gender === 'W';
  });
  
  updateTable(table2, subset2008);    
});
