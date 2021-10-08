# MultivariatePolynomialExponents
Provide the exponent matrix for a multivariate polynomial where the polynomial order can be different in each term.

Usage:

For a regular polynomial,
let D be the dimension of the problem,
let M be the polynomial order,

M = 3

polyexponents = get_exponents(2,M)

10×2 Matrix{Int64}:

 0  0
 
 1  0
 
 0  1
 
 2  0
 
 1  1
 
 0  2
 
 3  0
 
 2  1
 
 1  2
 
 0  3




For a polynomial with different maximum order in each dimension,
let D be the dimension of the problem,
let M be an array with the maximum polynomial order in each dimension,

M = [3, 1]

polyexponents = get_exponents(2,M)

7×2 Matrix{Int64}:

 0  0
 
 1  0
 
 0  1
 
 2  0
 
 1  1
 
 3  0
 
 2  1
