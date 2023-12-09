# Advent of Code 2023, Day 6

#### @aadmaa Learns Elixir
Problem descriptions are [here](https://adventofcode.com/2023/day/6), and summarized in script docs.

## Test

AoC provided sample data and an expected answer. Tests are created against that data prior to running the code against the "real" data.
```
mix test
```

## Notes
This one was straightforward. The A part could be handled discretely. Part B had larger numbers, so I created an algorithm to search efficiently for where the curve crossed a certain threshold. The curve is like an inverted parabaloid -- a hill basically.

So you have to find the spot going UP the hill, where you get over a certain elevation. Then you have to find a spot going DOWN. Or - I did it more like going up the hill from the other side. 

I didn't learn new Elixir but the exercise is good for getting used to function programming in Elixir.
