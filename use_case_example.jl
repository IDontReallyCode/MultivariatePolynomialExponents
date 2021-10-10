include("mpr.jl") 
# Until I figure out how to make a Julia Package

# using Plots
# using PyPlot
# using Plots, ElectronDisplay
# using Gnuplot
# Gnuplot.options.gpviewer = true 
# uncomment above to plot the function
# NVM, I can't make this s#%% to work in any way


function meshgrid(x, y)
	X = [x for _ in y, x in x]
	Y = [y for y in y, _ in x]
	X, Y
end

n_points = 100;
x = LinRange(100,102,n_points);
y = LinRange(100,102,n_points);

xx, yy = meshgrid(x, y);

z = sin.(xx[:]).*cos.(yy[:]);



# Fit a 15 by 10 order polynomial, polynomial with x up to power 15, y power up to 10, including cross product. 
# The maximum total order of x order + y order will be the maximum order, so 15
M = [15,10];
# M = 5
# You can check that the "fit" actually gets worse for the regular regression as you increase the polynomial order.

# Get the basis matrix of independent variables
independent_variable_matrix = [reshape(xx,n_points^2,1) reshape(yy,n_points^2,1)];

# Get the vector of coefficients for the multivariate polynomial
betaqr = mpregression(independent_variable_matrix, z, M);

# Check the fit without scaling
# Get the full matrix
X,E,S = PolyHorner([reshape(xx,n_points^2,1) reshape(yy,n_points^2,1)], M, false);
# apply the polynomial
z_hatqr = X * betaqr;
# get the errors
total_errorqr = sum(sqrt.( (z_hatqr.-z).*(z_hatqr.-z) ));
# print it
println("The total error of the regression I propose: $total_errorqr")
# println(total_errorqr)


# Now compare to a regular \ solve
# We will be nice and do the same scaling and obtain the full matrix
X,E,S = PolyHorner([reshape(xx,n_points^2,1) reshape(yy,n_points^2,1)], M, true);
# Do the normal regression, as proposed by most everyone.
betabs = X \ z
# Now, check the fit
z_hatbs = X * betabs;

total_errorbs = sum(sqrt.( (z_hatbs.-z).*(z_hatbs.-z) ));
println("The total error of the regular regression  : $total_errorbs")
# println(total_errorbs)


