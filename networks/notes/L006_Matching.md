# Network Analytics
Jim Leach  
14 December 2015  

# Matching

Matching is an important topic in the study of networks that comes up a lot in practice. Exampls include matching guest to rooms in hotels, matching buyers with sellers in a market place, ads to show to web-surfers, or perhaps matching kidney donors with those that need a kidney! These methods and algorithms and the related theory apply only to _bipartite_ graphs (graphs which are strictly divided in to two categories, with edges _only_ between the two groups).

## Kidney Exchange

Imagine two couples where one partner in both couples needs a kidney. If neither partner can donate to their spouse, but _can_ donate to the other partners' spouse, then we can see a matching problem develop. 

## The matching problem

In general, we will have more than just two sets of nodes in our graph. We will likely have thousands or many millions. Therefore matching becomes more complex: cycles are not permitted, prices/preferences on edges may complicate matters and the outcome must be compatible with these, and other, factors (e.g. regulations).

A __matching__ is defined as: _a subset of edges such that no two edges in the subset are incident on the same node._

A node is said to be _matched_ if an edge in the matching is incident on it. 

A __perfect matching__ is one in which _all_ nodes in the bipartition are matched. 

## Models of matching

There are many models of matching that are possible:

* Simple unweighted (find a perfect matching);
* Weighted - edges have weights;
* Matching with side constraints (e.g. in kidney exchange, matching with cycles of at most length k);
* Matching with preferences - each side ranks the other in terms of preference and we seek a "stable" matching;
* Online matching (stochastic) - matching where each node on the other side appears one after the other, e.g. ad-matching in real time.

## Bipartite graphs and matching

We generally will seek to find an optimial assignment or "matching". In this case, each node $i$ in one side of the graph has an edge to a node on the other side $j$ with some weight/value, denoted $v_{ij}$

One possible solution to this problem is to use linear programming (or other combinatorial algorithm). If $A$ is the node-edge incidence matrix of a bipartite graph then we can formulate this as an optimisation program where we seek to maximise the sum of the weights on the edges.

\begin{equation}
\begin{split}
\max v^Tx \\
s.t: \\
Ax = 1 \\
x \geq 0
\end{split}
\end{equation}

As A is totally unimodular this has the special property that the optimal solutions are integer. 

This can also be seen as a min-cost flow problem. If:

* the edges in the graph are directed as flows from node $i$ in one side to node $j$ on the other;
* a "source" node" is added ahead of node $i$ in the "from" side;
* a "sink node" is added on the other side of the "to" side; and
* all edges are assumed to have capacity 1

Then the min-cost flow problem can be solved using the weights on the edges ($v_{ij}$) to send n-unit(s) of flow from the source to the sink node (where n is the number of nodes on each side of the bipartite graph).

## Simple matching - finding the maximum size matching

Often we might seek to find a maximum-size matching

