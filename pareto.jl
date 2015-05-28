type GoldbergFitness{T}
  scores::Vector{T}
  rank::Integer

  GoldbergFitness(s::Vector{T}) = new(s)
end

type Wrapper
  fitness::GoldbergFitness{Float64}

  Wrapper(s::Vector{Float64}) = new(GoldbergFitness{Float64}(s))
end

function dominates{T}(x::Vector{T}, y::Vector{T}, maximise::Vector{Bool})
  dom = false
  for (i, xi) in enumerate(x)
    if xi != y[i]
      if (xi > y[i]) == maximise[i]
        dom = true
      else
        return false
      end
    end
  end
  return dom
end

type MOGAFitnessScheme
  maximise::Vector{Bool}
end

function process!(s::MOGAFitnessScheme, inds::Vector{Wrapper})
  for p1 in inds
    p1.fitness.rank = 1 + count(p2 -> dominates(p2.fitness.scores, p1.fitness.scores, s.maximise), inds)
  end
end

pts = [

  # Pareto Front-1.
  Wrapper([0.0, 0.0]),

  # Pareto Front-2.
  Wrapper([0.5, 6.0]),
  Wrapper([1.0, 5.0]),
  Wrapper([1.5, 4.0]),
  Wrapper([2.0, 3.0]),
  Wrapper([3.0, 2.5]),
  Wrapper([4.0, 2.0]),
  Wrapper([5.0, 1.5]),
  Wrapper([6.0, 1.0]),

  # Pareto Front-3.
  Wrapper([2.0, 6.0]),
  Wrapper([2.5, 5.0]),
  Wrapper([3.0, 4.0]),
  Wrapper([4.0, 3.0]),
  Wrapper([5.0, 2.5]),
  Wrapper([6.0, 2.0]),

  # Pareto Front-4.
  Wrapper([4.0, 6.0]),
  Wrapper([5.0, 4.0]),
  Wrapper([7.0, 3.0])
]

scheme = MOGAFitnessScheme([false, false])

process!(scheme, pts)

for p in pts
  println("$(p.fitness.scores): $(p.fitness.rank)")
end
