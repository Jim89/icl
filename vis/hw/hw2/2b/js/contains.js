// Function to test if an array contains and object
function contains(a, obj) {
    for (var i = 0; i < a.length; i++) {
        if (a[i] === obj) {
            return true;
        } else {
    	    return false;
        }
    }
}