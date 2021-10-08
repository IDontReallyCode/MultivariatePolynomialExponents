using Combinatorics
# , Transducers

function _exponents(D::Int,M::Int)
    # the function here generates all exponents in an array of vectors
    expo = collect(multiexponents(D,1))
    for i = 2:M
        println(i)
        expo = vcat(expo, collect(multiexponents(D,i)))
    end
    return expo
end

# b = collect(multiexponents(3,0))
# println(b)
# typeof(b)

e = exponents(2,3);
println(e)
typeof(e)
typeof(e[1])
typeof(e[2])


# """
# n ∈ N: length of array, i.e., x ∈ Rⁿ
# d ∈ N: degree
# """
