using Combinatorics
using StatsBase
using LinearAlgebra

function _exponents(D::Int,M::Int)::Matrix{Int}
    # the function here generates all exponents in a Matrix (nTerms, D)
    expV = vcat(collect(multiexponents(D,0)))
    for i = 1:M
        expV = vcat(expV, collect(multiexponents(D,i)))
    end
    s = size(expV)
    expM = zeros(Int,s[1],D)
    for i=1:s[1]
        expM[i,:] = expV[i][:]'
    end
    return expM
end

function get_exponents(D::Int, M::Int)::Matrix{Int}
    # This function will simply return the array of arrays for the exponents of order M in each dimension
    return _exponents(D,M)
end

function get_exponents(D::Int, M::Union{Array{Int64}, Vector{Int64}})::Matrix{Int}
    # This function will return the exponent matrix, respecting the maximum for each dimension
    expM = _exponents(D,maximum(M))

    for i = 1:D
        expM = expM[expM[:,i].<=M[i],:]
    end

    return expM
end

function PolyHorner(Xin::Array{Float64}, M::Union{Int64, Array{Int64}, Vector{Int64}}, Scale=true)::Tuple
    # this function is "semi" optimized to generate the polynomial matrix follow the order of the polynomial Matrix
    # At least a portion of the polynomial building id optimized based on Horner's method.
    #  https://en.wikipedia.org/wiki/Horner%27s_method
    # TODO add the option to use bigfloats
    # TODO allow asking for inverse. Where   y = a + bx + cx^2 + d(1/x) + e(1/x^2)

    N = size(Xin,1);
    D = size(Xin,2);
    # println(typeof(M))

    if isa(M, Number)
        maxM = M
        M = ones(Int, D,1).*M
        # println("we converted to vector")
    else
        # println("The test did not work")
        maxM = maximum(M)
    end

    if Scale
        scalingX = zeros(Float64, D, 1)
        for i = 1:D
            scalingX[i,1] = std(Xin[:,i])
            Xin[:,i] = Xin[:,i] ./ scalingX[i,1]
        end
    end

    exp = get_exponents(D, M)
    nterms = size(exp,1)

    Xes = fill(zeros(Float64, N, maxM),D)

    for i = 1:D
        Xes[i] = zeros(N,M[i])
        Xes[i][:,1] = Xin[:,i]
        for j = 2:M[i]
            Xes[i][:,j] = Xes[i][:,j-1] .* Xes[i][:,1]
        end
    end

    Xmatrix = ones(Float64, N, nterms)
    for term = 1 : nterms
        for dim = 1 : D
            if exp[term, dim]>0
                Xmatrix[:,term] = Xmatrix[:,term] .* Xes[dim][:,exp[term, dim]]
            end
        end
    end

    # poly_matrix = Dict("X"=>Xmatrix, "exp"=>exp, "scaling" => scalingX)

    return Xmatrix, exp, scalingX
end


function _myregressqr(y::Vector, X::Matrix)::Vector
    # Quick and dirty QR decomposition
    # Check your matrix size yourself ;-)
    # in my experience, this is the method least suseptible to numerical issues
    QRP = qr(X, Val(true))

    beta = zeros(Float64, size(X,2), 1)
    
    betaqr[QRP.p] = QRP.R \ ((Matrix(QRP.Q))' * y)
    
    return betaqr[:]
end

function mpregression(x::Matrix, y::Vector, M::Union{Int64, Array{Int64}})::Vector
    # Use this to fit a (multivariate) polynomial on a function
    # x is a matrix. Each column is for one independent variable
    # y is a vector.
    # M is either an integer for the polynomial order, or a vector for the maximum polynomial order in each independent variable.
    # make sure the size of M matches the number of independent variables.
    # Please check your sizes and types yourself ;-)
    
    X, exp, scalings = PolyHorner(x,M)

    beta = _myregressqr(y, X).*scalings

    return beta

end













