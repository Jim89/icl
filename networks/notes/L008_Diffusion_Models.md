# Network Analytics
Jim Leach  
14 December 2015  

# Diffusion Models

Diffusion models can be used to understand how things spread. Often there is no explicit network in the model, in which case we refer to it as a "population model", i.e. we presume a 100% connected network. If there _is_ a network then we would refer to it as a network-topology based model. 

## Motivation

The movtivation is to understand the adoption of a new product or idea over time. Often this will be affected by externalities (either positive or negative). Recall that externalities are things which are not part of the product but which might affect it or its success (e.g. the number of people using a new social network). In general, there is some critical mass for a product to reach or it will fail. 

Recall that externalities can be positive or negative. They can also be forced (e.g. _everyone_ is on WhatsApp, so I need WhatsApp) or choice-based (e.g. "jumping on the bandwagon" or the inverse - snobbery - "Facebook is only cool with my mum and dad, I'm not interested").

We must model these things with ituitive, common sense features as we rarely have physical tests that we can perform to verify our results.

## Modelling the market without a network

### Demand curves

Often we will need to use _demand curves_:

![](L008_Diffusion_Models_files/figure-html/plot_demand-1.png)<!-- -->


A demand curve plots price on the y-axis and demand ($x$) on the x-axis. Demand is the fraction of the market that would purchase the product.

The (strictly decreasing) line is $r(x)$ and represents the fraction of consumers that would be captured by selling the product at price, p (or lower). $r(x)$ represents the maximum willingness of a consumer to pay and is termed the _reservation price_.

The graph orders customers in decreasing order of willingness to pay and therefore the fraction who _do_ purchase is termed $r^{'}(x)$. 

If the market price for a good is $p$, everyone who wants to buy the good can do so at price p. No units are sold above or below p. At p, everyone with a reservation price $\geq$ p will buy the good, and everyone else will not. Therefore, at a price of r(0) or more, no one will buy it and at a price r(1) or less, everyone will. 

However, between r(0) and r(1) there is a number x with the property that r(x) = p. At this point, all consumers between 0 and x buy the product, and anyone above x does not. This can be performed for every price and so, we can read this relationship between price and quantity purchased as the demand for the good. 

### Equilibrium

Imagine that the amount produced has no influence on the market price, and that they are many small producers and many consumers. 

Imagine there is some cost, $p^*$ which is how much it costs to produce 1 unit of the product. If we sell below this product, we will loose money, if we sell above it, consumers will buy from other suppliers who sell at $p^*$. 

This then is the equilibrium price, the price at which no 1 consumer switches supplier. 

To complete this picture we can determine the _supply_ of the good. Since $p^*$ is somewhere between the highest and lowest reservation prices (ignoring cases where is is > r(0) or < r(1)) we can find a unique x, termed $x^*$ between 0 and 1 such that r($x^*$) = $p^*$. $x^*$ is termed the _equilibrium quantity_ of the good given the reservation prices and the cost p*. 

## Adding network effects

We can also add network effects to the model. Imagine now that there are two functions at work in determining a customers willingness to pay. The r(x) value seen earlier (which is a measure of intrinsic value) and f(z), where z represents the fraction of the population using the good. 
Combining these two, the new reservation price of consumer x is r(x)f(z) - r(x) is still the intrinsic level of interest a consumer has, and f(z) measures the benefit to the consumer when z fraction of the population are using it. 

f(z) is increasing in z, it controls how much more valuable the product is with more people using it. The multiplicative nature of the new reservation price ensures that customers with a high instrinsic value (a high r(x)) will benefit more from a higher z. 

Generally, we assume that f(0) = 0, i.e. if no one uses the good then it is worthless to everyone. Since a consumers willingness to pay depends on z, each consumer needs to predict z in order to evaluate their value. Suppose that the price is p' and that a consumer expects z to use the good, then the consumer will want to purchase provided that r(x)f(z) $\geq$ p'.

### The big question - predicting z

For an individual consumer, we are interested in understanding how they predict z, and hence know their own valuation. To do so we use the concept of a _rational equilibrium_ (also termed self-fulfilling) whereby if eveyone expects z, then z is the equilibrium value. 

By this we mean that consumers form a shared expectation that the fraction of the population using the product is $z$. If each makes a decision based on this expectation, then the fraction of people who _actually purchase_ is z!

## Modelling the equilibrium

In terms of price p' > 0:

If everyone expects z = 0 then no one will want to purchase (recalling that f(0) = 0), and the shared expectation of z has been fulfilled! Now consider a value of z strictly between 0 and 1. If exactly z fraction of the pop purchases the goods then the set of purchases will be those consumers between 0 and z. This is becauseif x' purchases the good, and x < x' then consumer x will purchase it as well.

We might want to determine what is the price, $p^*$ at which these consumers want to purchase. The lowest resetvation price in this set will belong to consuder z who, due to the shared expectations, has a reservation price of r(z)f(z). In order to exactly this set of consumers (and no one else) to purchase the good, we must have $p^*$ = r(z)f(z).

This can be summarised:

> If price $p^*$ >0 together with z strictly between 0 and 1 form a self-fulfilling expectations equilibrium then $p^*$ = r(z)f(z)

### A specific example

Consider the specific example where r(x) = 1 -x and f(z) = z. At equilibrium x = z (i.e. the fraction who purchase = the fraction using the product) by the above self-fulfilling logic.

Plotting r(x)f(z) against z we see this:

![](L008_Diffusion_Models_files/figure-html/show_z-1.png)<!-- -->

This has parabolic shape and is 0 at z = 0 and 1 and has a maximum at z = 0.5 (where it equals 0.25). (Of course in general r(.) and f(.) need not look exactly like this, but they typically look _something_ like this).

Recall that at equilibrium $p^*$ = r(z)f(z). 

If $p^*$ > 0.25, then there is no solution to $p^*$ = r(z)f(z) = z(1-z) (since the RHS has a maximum value of 0.25 at z = 0.5). As such the only equilibrium is when z = 0. This is a good that is simply too expenseive, and so the only equilibrium is when no one expects it to be used. 

On the other hand, if $p^*$ is between 0 and 0.25, then there are two solutions to $p^*$ = r(z)f(z) = z(1-z), we can term these the points z' and z''. Thus in this case there are three equilibria: one at z = 0 and two more at z' and z''. For each of these values, if people expect the corresponding fraction of the populatin to buy the good, then precisely that fraction of the population between 0 and the value will do so. 

This corresponds to "consumer confidence" - if people expect a product to be good, it often will be. 

## Stability, Instability and Tipping Points

Continusing on the above example:

* If z is between 0 and z', then there is "downward pressure" on consumption. Since r(z)f(z) < $p^*$, purchaser at z (and just below z) will value the good at less than p and hence will wish they hadn't bought it.
* If z is betwen z' and z'', then there is "upwards pressure". Since r(z)f(z) > $p^*$ consumers slightly above z have no purchased the good but will wish that they had.
* If z is above z'' then there is again downwards pressure: since r(z)f(z) < $p^*$ then purchaser z and others just below it will wish they had no bought.

This has interesting consequences. It shows that z'' has a strong _stability_, if z near to z'' occurs, then we tend either upwards or downwards to z''. This is not the case in the vicinity of z', if z is just below it and we tend to z = 0, just above it and we will tend to z''. Thus if _exactly_ z' buys the good then we reach equilibrium, else we move up or down towards z = 0 or z = z''.

Therefore z' is both an _unstable_ equilibrium and a _tipping point_ in the success of the good. If we can get z just above z', we will tend to z'' in the long run. 

Another way to look at this is to consider the case where there is a belief _and_ a reality. I.e., consumer beliefs might be wrong. 

This means that, if everyone believes that a z fraction of the pop will use the product, then consumer x, based on that belief, will want to purchase it r(x)f(x) $\geq p^*$. Hence, if anyone wants to purchase, the set of people who _will_ is between 0 and $\hat{z}$ where $\hat{z}$ solves the equation r($\hat{z}$)f(z) = $p^*$ or, rather:

\begin{equation*}
r(\hat{z}) = \dfrac{p^*}{f(z)}
\end{equation*}

or taking the inverse

\begin{equation*}
\hat{z} = r^{-1} (\dfrac{p^*}{f(z)})
\end{equation*}

This allows a way to compute the outcome, $\hat{z}$ from the shared expectation, z. We can define a function, g(z) that describes this, given that r(.) is continuous and decreasing from r(0) to r(1). When the shared expectation z $\geq$ 0 then the outcome $\hat{z} = g(z)$ where $g(z) = r^{-1} (\dfrac{p^*}{f(z)})$ when the condition that $\dfrac{p^*}{f(z)}\leq r(0)$ holds and g(z) = 0 otherwise. 

Again, continuing the example from before where r(x) = 1-x and f(z) = z. In this case $r^{-1}$(x) turns out to be 1-x and z(0) = 1. Therefore in this example g(z) = 1- $\frac{p^*}{z}$ when z $\geq p^*$ and g(z) = 0 otherwise. 

We can plot this on a graph and compare it to the 45deg line where $\hat{z} = z$. This provides striking visual summary of the issues around equilibrium. Equilibria occur when g(z) = z. We prefer the higher equilibrium at z'' as more people are buying our product! The equilibria are either stable or unstable depending on whether the reality line crosses the expectations line from above or below (respectively).

Again, we can describe the pressures at each point on the graph:

* If $\hat{z}$ < z then people drop out and/or are less likely to purchase, therefore $\hat{z}$ decreased further;
* If $\hat{z}$ > z then $\hat{z}$ tends to increase and people are more likely to purchase.

The first equilibrium is the tipping point we need to reach to get market share ($\hat{z}$) increasing and the second equilibrium is stable. 

### The effect of price

g(z) = 1 - ($p^*$/z), i.e. if we decrease the price, g(z) will increase (more people purchase).

## Dynamics

Generally expectations shift with reality, i.e. if reality is > expectations, then expectations increase, if reality < expecations, then expecations decrease.

## Market penetration pricing strategy

If we price very low initially (e.g. below cost) then which equilibria do we achieve? Whatever consumer expecations have (z), we want $\hat{z}$ to be > z. Recall also that r($\hat{z}$)f(z) = p, so we just have to price low enough such that r(z')f(z) > p.

## More than two non-zero equilibria

If we ahve non-linear functions for r(x) and f(z), e.g. r(x) = 1 - x and f(x) = 1 + az^2^ then the shape of our $\hat{z}$ vs z curve will look different. The value to the consumer if a fraction z adopts the product is now r(x)f(x) = (1-x)(1+az^2^) and therefore g(z) = 1- ($p^*$/(1+az^2^)).

It may not be the case that 0 is an equilibrium, for example in the above function f(0) = 1, i.e. consumers will retain some intrinsic value even if no one else is using it.

However, we will still get at least one stable and at least one unstable equilibrium. However, there may now be several stable equilibria with different profitablities. 

When moving along the curve, there may be bottlenecks when g(z) is only _just_ above z, therefore $\hat{z}$ does not increase much. Note that these bottlenecks will only last so long. 

# The Bass Model

An altnerative model of diffusion is the Bass model. It was introduced in the 60's to describe product adoption and is the most widely used model even today. It requires no network structure (i.e. it is a population model). 

\begin{equation*}
F(t+1) = F(t) + p(1-F(t)) + q(1-F(t))F(t)
\end{equation*}

* F(t) is the fraction of the population who have adopted at time, t
* p is the rate of spontaneous adoption; and
* q is the rate of imitation (i.e. getting the product because someone else does)

For small time periods, we can use the differential equation:

\begin{equation*}
\frac{F(t)}{dt} = (p+qF(t))(1-F(t))
\end{equation*}

I.e when F(t) nears 1, the derivative approaches 0 and growth slows, when F(t) = 0, the derivative is p and growth is only due to spontaneous adoption.

The solution to this is:

\begin{equation*}
F(t) = \dfrac{1 - e ^{-(p+q)t}}{1+ \frac{q}{p}e^{-(p+q)t}}
\end{equation*}

This gives and S-shapre (if q>p) that tends to 1 in the limit. Initially, only p matters and then q takes over. 







