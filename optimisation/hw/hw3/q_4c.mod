### set up decision variables ------------------------------------------------------------------------------------------
# binary choices for each supplier
var dcw binary;
var dnm binary;
var dafd binary;
var dlac binary;
var ddm binary;
var ddm2 binary;

# amount to purchase from each supplier
var cw;
var nm;
var afd;
var lac;
var dm;		# new variable for DM supplier
var dm2;	# new variable for DM supplier extra supply

# set up objective ------------------------------------------------------------------------------------------
minimize cost: 	10000*dcw + 2500*cw + # costs for CW
				20000*dnm + 2450*nm + # costs for NM
				0*dafd + 2510*afd + 	# costs for AFD
				13000*dlac + 2470*lac + # costs for LAC
				9000*ddm + 2530*dm + 	# costs for DM (base level)
				7000*ddm2 + 2430*dm2;	# costs for DM (at extra purchase)

### set constraints ------------------------------------------------------------------------------------------
# total furniture requirement
subject to cap: cw + nm + afd + lac + dm + dm2 >= 2000;

# bid/capacity limits (each producer can only send so much)
subject to cw_bid: cw <= 1000;
subject to nm_bid: nm <= 1200;
subject to afd_bid: afd <= 800;
subject to lac_bid: lac <= 1100;
subject to dm_bid: dm <= 1000;
subject to dm2_bid: dm2 <= 500;

# fixed charge problem - need to ensure that binary decision variable = 1 if that supplier is bought from
subject to cw_dec: cw <= 1000000*dcw;
subject to nm_dec: nm <= 1000000*dnm;
subject to afd_dec: afd <= 1000000*dafd;
subject to lac_dec: lac <= 1000000*dlac;
subject to dm_dec: dm <= 1000000*ddm;
subject to dm2_dec: dm2 <= 1000000*ddm2;

# Extra capacity from DM (i.e. dm2) is only available if 1000 units are purchased at the "base" cost (i.e. dm)
# can only purchase the extra if the base costs are paid
subject to dm2_only_if_dm: ddm2 <= ddm;
# further restriction - can only purchase the extra if 1000 units are purchased from DM 
subject to dm_2_only_if_1000_dm: 1000*ddm2 <= dm;

# can't have negative purchasing!
subject to nn_cw: cw >= 0;
subject to nn_nm: nm >= 0;
subject to nn_afd: afd >= 0;
subject to nn_lac: lac >= 0; 
subject to nn_dm: dm >= 0;
subject to nn_dm2: dm2 >= 0;
