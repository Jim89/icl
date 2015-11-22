# set up decision variables
var sf;
var b;
var hm;
var vc;

# set up function
maximize earnings: 0.22*sf + 0.2*b + 0.18*hm + 0.18*vc;

# add constraints
subject to carrots: 0.0625*sf + 0.05*b + 0.0625*vc <= 3750;
subject to mushrooms: 0.075*sf + 0.1*hm <= 2000;
subject to green_peppers: 0.0625*sf + 0.05*b + 0.075*hm + 0.0625*vc <= 3475;
subject to broccoli: 0.05*sf + 0.075*b + 0.075*hm + 0.0625*vc <= 3500;
subject to corn: 0.075*b + 0.0625*vc <= 3750;

# add non-neg constrains
subject to sf_nn: sf >= 0;
subject to b_nn: b >= 0;
subject to hm_nn: hm >= 0;
subject to vc_nn: vc >= 0;
