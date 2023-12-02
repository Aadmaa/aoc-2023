# Advent of Code 2023, Day 1

#### @aadmaa Learns Elixir
Problem descriptions are [here](https://adventofcode.com/2023/day/1), and summarized in script docs.

## Test

AoC provided sample data and an expected answer. Tests are created against that data prior to running the code against the "real" data.
```
mix test
```

## Run

```
iex

c "lib/day01.ex"
Day01.main("data/maindata.txt")
# Result: 55607

c "lib/day01b.ex"
Day01B.main("data/maindata.txt")
# Result: 55291
```

## Notes
Learned: Reading from a file stream, and applying functions to each line. Tail recursion on lists, to "reduce" list to a value.
