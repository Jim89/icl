# Network data explorer

This Shiny application serves as a way to interact with some social network data
collect as part of the [MSc Business Analytics](http://wwwf.imperial.ac.uk/business-school/programmes/msc-business-analytics/) at Imperial College London.

Students were asked to select other students for a variety of tasks and the results
used to form several social networks. 

Further analysis will be performed on these networks as part of the course.

Please note that due to a limitation in the `R` package used to visualise the networks
(the [`networkD3`](https://christophergandrud.github.io/networkD3/) package) on nodes that are connected
in both directions are joined in the resulting diagram (i.e. both people selected each other). This is a known issue and is being addressed at the moment. 

The creator of this app blogs [here](www.thedatagent.com).
