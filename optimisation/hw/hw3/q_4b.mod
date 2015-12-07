# set up decision variables
var dcw binary;
var dnm binary;
var dafd binary;
var dlac binary;

var cw;
var nm;
var afd;
var lac;

# set up objective
minimize cost: 10000*dcw + 2500*cw + 20000*dnm + 2450*nm + 0*dafd + 2510*afd + 13000*dlac + 2470*lac;

# set constraints
subject to cap: cw + nm + afd + lac >= 2000;
subject to cw_dec: cw <= 1000000*dcw;
subject to nm_dec: nm <= 1000000*dnm;
subject to afd_dec: afd <= 1000000*dafd;
subject to lac_dec: lac <= 1000000*dlac;

subject to nn_cw: cw >= 0;
subject to nn_nm: nm >= 0;
subject to nn_afd: afd >= 0;
subject to nn_lac: lac >= 0; 

