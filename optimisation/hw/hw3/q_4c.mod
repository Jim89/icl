# set up decision variables
var dcw binary;
var dnm binary;
var dafd binary;
var dlac binary;
var ddm binary;
var ddm2 binary;

var cw;
var nm;
var afd;
var lac;
var dm;
var dm2;

# set up objective
minimize cost: 10000*dcw + 2500*cw + 20000*dnm + 2450*nm + 0*dafd + 2510*afd + 13000*dlac + 2470*lac + 9000*ddm + 2530*dm + 7000*ddm2 + 2430*dm2;

# set constraints
subject to cap: cw + nm + afd + lac + dm + dm2 >= 2000;

subject to cw_bid: cw <= 1000;
subject to nm_bid: nm <= 1200;
subject to afd_bid: afd <= 800;
subject to lac_bid: lac <= 1100;
subject to dm_bid: dm <= 1000;
subject to dm2_bid: dm2 <= 500;

subject to cw_dec: cw <= 1000000*dcw;
subject to nm_dec: nm <= 1000000*dnm;
subject to afd_dec: afd <= 1000000*dafd;
subject to lac_dec: lac <= 1000000*dlac;
subject to dm_dec: dm <= 1000000*ddm;
subject to dm2_dec: dm2 <= 1000000*ddm2;

subject to dm2_only_if_dm: ddm2 <= ddm;
subject to dm_2_only_if_1000_dm: 1000*ddm2 <= dm;


subject to nn_cw: cw >= 0;
subject to nn_nm: nm >= 0;
subject to nn_afd: afd >= 0;
subject to nn_lac: lac >= 0; 
subject to nn_dm: dm >= 0;
subject to nn_dm2: dm2 >= 0;
