# set decision variables
var f;
var xsa;
var xsb;
var xsc;
var xad;
var xbe;
var xca;
var xcb;
var xcd;
var xce;
var xdt;
var xed;
var xet;

# set up function
maximize flow: f;

# add flow constraints
subject to fc1: f - xsa - xsb - xsc == 0;
subject to fc2: xad - xsa - xca == 0;
subject to fc3: xbe - xsb - xcb == 0;
subject to fc4: xca + xcb + xcd + xce - xsc == 0;
subject to fc5: xdt - xad - xcd - xed == 0;
subject to fc6: xed + xet - xbe - xce == 0;
subject to fc7: f -xdt - xet == 0;

# add non-neg constrains
subject to nn1: xsa >= 0;
subject to nn2: xsb >= 0;
subject to nn3: xsc >= 0;
subject to nn4: xad >= 0;
subject to nn5: xbe >= 0;
subject to nn6: xca >= 0;
subject to nn7: xcb >= 0;
subject to nn8: xcd >= 0;
subject to nn9: xce >= 0;
subject to nn10: xdt >= 0;
subject to nn11: xed >= 0;
subject to nn12: xet >= 0;


# add varaible constraints
subject to c1: xsa <= 5;
subject to c2: xsb <= 3;
subject to c3: xsc <= 13;
subject to c4: xad <= 3;
subject to c5: xbe <= 4;
subject to c6: xca <= 7;
subject to c7: xcb <= 5;
subject to c8: xcd <= 2;
subject to c9: xce <= 2;
subject to c10: xdt <= 5;
subject to c11: xed <= 9;
subject to c12: xet <= 10;

