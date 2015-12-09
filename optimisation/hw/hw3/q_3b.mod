var d1 binary;
var d2 binary;
var d3 binary;
var d4 binary;
var y binary;

var x1;
var x2;
var x3;
var x4;


# set up objective ------------------------------------------------------------------------------------------
maximize profit: 70*x1 + 60*x2 + 90*x3 + 80*x4 - 50000*d1 - 40000*d2 - 70000*d3 - 60000*d4;

# set constraints
subject to nn1: x1 >= 0;
subject to nn2: x2 >= 0;
subject to nn3: x3 >= 0;
subject to nn4: x4 >= 0;

subject to enforce_cost1: x1 <= 1000000*d1;
subject to enforce_cost2: x2 <= 1000000*d2;
subject to enforce_cost3: x3 <= 1000000*d3;
subject to enforce_cost4: x4 <= 1000000*d4;

subject to capacity1: x1 <= 10000;
subject to capacity2: x2 <= 15000;
subject to capacity3: x3 <= 12500;
subject to capacity4: x4 <= 9000;

subject to at_most_2: d1 + d2 + d3 + d4 <= 2;

subject to 3_only_with_1_or_2: d3 <= d1 + d2;

subject to either: x1 + x1 <= 20000 + 1000000*y;
subject to or: x3 + x4 <= 20000 + 1000000*(1-y);