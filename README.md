# MultivariatePolynomialFit
# Use this to fit a (multivariate) polynomial on a function
    # x is a matrix. Each column is for one independent variable
    # y is a vector.
    # M is either an integer for the polynomial order, or a vector for the maximum polynomial order in each independent variable.
    # make sure the size of M matches the number of independent variables.
    # Please check your sizes and types yourself ;-)
    

Building the polynomial follows, mostly, Horner's method to make it more efficient.
The multivariable polynomial can be or different order in each independent variable (dimension).
The regression uses a QR pivoted decomposition, which is far less susceptible to numirecal issues caused by rounding errors.

