# Advent of Code 2023, Day 2

#### @aadmaa Learns Elixir
Problem descriptions are [here](https://adventofcode.com/2023/day/2), and summarized in script docs.

## Test

AoC provided sample data and an expected answer. Tests are created against that data prior to running the code against the "real" data.
```
mix test
```

## Run

```
iex

c "lib/day02.ex"
Day02.main("data/maindata.txt")
# Result: 2239

c "lib/day02b.ex"
Day02B.main("data/maindata.txt")
# Result: 83435
```

## Notes
Learned: More practice with a functional workflow, applying transformations to subsequent lines of data; and reducing results to a single value. Use of more string functions. More Enum functions. Noted really nifty filtering and max/min functions in Elixir's Enum. Using pattern matching to deconstruct values from an array (e.g., following String.split()). 

Following this challenge I re-created the project using an Elixir umbrella app, tests, and these README files. Thus learning how to set up an umbrella project and how to use Elixir's built-in testing system. (Super easy!) 

AoC projects seem well-defined to support TDD programming.