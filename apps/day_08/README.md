# Advent of Code 2023, Day 8

#### @aadmaa Learns Elixir
Problem descriptions are [here](https://adventofcode.com/2023/day/6=8), and summarized in script docs.

## Test

AoC provided sample data and an expected answer. Tests are created against that data prior to running the code against the "real" data.
```
mix test
```

## Notes: about Elixir
Mainly I learned that when umbrella projects use one another, it's important to set the interdependencies up in the mix.exs of the App that depends upon another App. E.g., to depend on Common: 

```
  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:common, in_umbrella: true}
    ]
  end
```

I also got more comfortable using recursive functions to solve problems that I'd normally use loops for. See "increment_startpoints()" for example. 

It is surprising how easy it is to reason about recursion in this language, as compared with others.

## Notes: about the problem
Part B requires some mathematical thinking. Specifically, from each starting point, an infinite cycle will eventually emerge. Specifically, if you are in the same spot on the "directions" list (L-R-L-R-R etc), say index 5; and you are on the same starting location when you get there; then you have already been here before. 

We want to know the number of turns it takes to get to a place ending with Z from each A -- and for all possible ways to get from each A to ANY "Z" endpoint. 

So we traverse the entire cycle, cache places we have been before, and track total turn-counts that get us to a Z.

We do this seperately for each "A" starting point. No need to keep the cache between them. At the end we just have the possible number of turns to get to each starting point, so if there were 3 starting points, we might have 

[
  [123, 156789],
  [456],
  [34, 234, 5677]
]

...an array which contains one array for each starting point ending in A, like "XXA". So if we took 123 turns, or 156789 turns for the first starting point, we will arrive at a place that ends in Z, like "BBZ".

Now we can use any ONE of the elements of EACH array to find out how to get every location to an endpoint together. Specifically we can take the prime factors from a group, e.g., form 123, 456, 34, and multiply them all together. 

We try all the variations of elements from each array, and we take the lowest possible outcome, and that's the answer.
