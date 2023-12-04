# Advent of Code 2023, Day 3

#### @aadmaa Learns Elixir
Problem descriptions are [here](https://adventofcode.com/2023/day/3), and summarized in script docs.

## Test

AoC provided sample data and an expected answer. Tests are created against that data prior to running the code against the "real" data.
```
mix test
```

## Run

```
iex

c "lib/day03.ex"
Day03.main("data/maindata.txt")

c "lib/day03b.ex"
Day03B.main("data/maindata.txt")
```

## Notes
After I solved the first problem I learned "Stream.chunk_every" which makes it very easy to look at three rows of data at a time (like [Row1 , Row2, Row3] then [Row2, Row3, Row4]).

Without this method, I had loaded the who file in memory instead of using a File.stream(). This solution is in "day03_original.exs" and would not work for arbitrarily large file.

As I started "B" I learned how to use chuck_every, and went back and refactored the first puzzle.

WHile debugging Part B, I got to know Elixir's weird way of writing an array of numbers, if they happen to be ASCII-looking. I thought I had a really odd bug ... but of course, Elixir just treats an array of numbers as a string when it displays the array (e.g., with IO.puts/1).
