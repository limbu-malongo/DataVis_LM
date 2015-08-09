############################################################################
#
#     Coursera Data Visualization Course
#     Instructor: John C. Hart
#     Programming Assignment 2: Visualize Network Data
#     August 2015
#
#############################################################################

# Prepare the environment
# install.packages("igraph")
library(igraph)

# Download the data (Gnutella Peer-to-Peer Network)
# From http://snap.stanford.edu/data/index.html
# http://snap.stanford.edu/data/p2p-Gnutella04.html

# Uncompress the data and put the data into your working directory
# If you are using Windows Operating System you may use 7-zip to uncompress
# http://www.7-zip.org/

# Importing data for social network analysis
# choose an adjacency matrix from a .csv file
dat=read.table("p2p-Gnutella04.txt", 
               header= FALSE, 
               colClasses = "character", 
               skip = 4)  # The first 4 lines contain comments

# Checking the top data
head(dat)

dim(dat) # The firt number of dimension should match the number of edges 39994

str(dat)

# Add the columns names
names(dat) <- c("FromNodeId", "ToNodeId")
head(dat, 3)

# coerces the data into a two-column matrix format that igraph likes
el=as.matrix(dat)

g=graph.edgelist(el,directed=TRUE) # turns the edgelist into a 'graph object'
g

# Visualize the graph (all the nodes)
# Be patient the graphic may take sometime to be processed and displayed
plot.igraph(g)

# That doesn't look very good. Let's start fixing things by removing the loops 
# in the graph and modifying the nodes and edges attributes.
g <- simplify(g, remove.multiple = F, remove.loops = T) 

# Decolarating the graph
V(g)$frame.color <- "red"
V(g)$color <- "orange"
V(g)$label <- ""
V(g)$size <- 2
E(g)$arrow.size <- .2
E(g)$color <- "blue"

# Producing the second plot
# Be patient the graphic may take sometime to be processed and displayed
par(mar = c(0.5, 4, 2, 2) + 0.1)
set.seed(39)
l <- layout.fruchterman.reingold(g)
l <- layout.norm(l, ymin=-1, ymax=1, xmin=-1, xmax=1)
plot.igraph(g,
     main = "Gnutella peer-to-peer network, August 4 2002",
     rescale=F, 
     layout=l*1.3)

par(mar = c(5, 4, 4, 2) + 0.1)


# Exploring the community structure

# --- From http://www.cs.upc.edu/~CSN/slides/07communities.pdf Slide 6

# ------------ Some Theory ----------------------------------

# Main idea
# i.e identification of major cohesive subgroups(major clusters)

# "A community is dense in the inside but sparse w.r.t. the outside"

# - A community should be densely connected
# - A community should be well-separated from the rest of the network
# - Members of a community should be more similar among themselves 
# - than with the rest

# Most common..
# nr. of intra-cluster edges > nr. of inter-cluster edges

# ----------------------------------------------------------------

# Contracting and simplifying a network graph

# The following code is a modified code from
# http://blog.revolutionanalytics.com/2015/08/contracting-and-simplifying-a-network-graph.html

gs=graph.edgelist(el,directed=FALSE) # turns the edgelist into a 'graph object'

set.seed(42)
# Compute communities (clusters)
cl <- walktrap.community(gs, steps = 5)
cl$degree <- (degree(gs)[cl$names])

# Assign node with highest degree as name for each cluster
cl$cluster <- unname(ave(cl$degree, cl$membership, 
                         FUN=function(x)names(x)[which.max(x)])
)
V(gs)$name <- cl$cluster

# Contract graph ----------------------------------------------------------

# Contract vertices
E(gs)$weight <- 1
V(gs)$weight <- 1
gcon <- contract.vertices(gs, cl$membership, 
                          vertex.attr.comb = list(weight = "sum", name = function(x)x[1], "ignore"))

# Simplify edges
gcon <- simplify(gcon, edge.attr.comb = list(weight = "sum", function(x)length(x)))

gcc <- induced.subgraph(gcon, V(gcon)$weight > 20)
V(gcc)$degree <- unname(degree(gcc))

#  ------------------------------------------------------------------------

V(gcc)$frame.color <- "red"
V(gcc)$color <- "orange"
V(gcc)$size <- 1.2 * (V(gcc)$degree)
E(gcc)$arrow.size <- .1
E(gcc)$color <- "blue"

set.seed(42)
par(mar = c(0.5, 2, 2, 2) + 0.1)
g.layout <- layout.fruchterman.reingold(gcc)

plot.igraph(gcc,
            main = "Community Structure for Gnutella peer-to-peer network, August 4 2002",
            layout = g.layout 
            )
# Restore default parameters
par(mar = c(5, 4, 4, 2) + 0.1)


# -----------------------------------------------------------------

# References

# J. Leskovec, J. Kleinberg and C. Faloutsos. Graph Evolution: Densification 
# and Shrinking Diameters. ACM Transactions on Knowledge Discovery from 
# Data (ACM TKDD), 1(1), 2007.
# url: http://www.cs.cmu.edu/~jure/pubs/powergrowth-tkdd.pdf

# M. Ripeanu and I. Foster and A. Iamnitchi. Mapping the Gnutella 
# Network: Properties of Large-Scale Peer-to-Peer Systems and Implications 
# for System Design. IEEE Internet Computing Journal, 2002.
# http://snap.stanford.edu/data/p2p-Gnutella04.html

# Create Basic Visualizations
# http://web.stanford.edu/~messing/CreateBasicNetVis.html

# Social Networks in R
# http://www.shizukalab.com/toolkits/sna/sna_data

# Static and dynamic network visualization with R
# http://kateto.net/network-visualization

# Contracting and simplifying a network graph
# http://blog.revolutionanalytics.com/2015/08/contracting-and-simplifying-a-network-graph.html

# Community strucure via short random walks
# http://www.inside-r.org/packages/cran/igraph/docs/walktrap.community

# Computing communities in large networks using random walks (long version)
# http://arxiv.org/abs/physics/0512106

# Finding Communities In Networks With R And Igraph
# http://www.sixhat.net/finding-communities-in-networks-with-r-and-igraph.html

