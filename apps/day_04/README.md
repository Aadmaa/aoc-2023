# Advent of Code 2023, Day 4

#### @aadmaa Learns Elixir
Problem descriptions are [here](https://adventofcode.com/2023/day/4), and summarized in script docs.

## Test

AoC provided sample data and an expected answer. Tests are created against that data prior to running the code against the "real" data.
```
mix test
```

## Run

```
iex

c "lib/day04.ex"
Day04.main("data/maindata.txt")
# Result: 32609

c "lib/day04b.ex"
Day04B.main("data/maindata.txt")
# Result: 14624680
```

## Notes
The trickiest bit here for me was in Part B:
```
rez_final =  
  if winner_count > 0 do
    Enum.reduce(1..winner_count, rez, fn i, acc ->
      # Looking ahead, we add A' to the current value
      Map.update(acc, index+i, final_cards_at_index, fn existing_value -> existing_value + final_cards_at_index end)
    end)
  else
    rez
  end
```
In OO programming one would simply loop *winner_count* times, and update the Map object. 

You can't do that in Functional Programming. So you Reduce a stream of integers from 1 to *winner_count*, and update the Map into the accumulator. 