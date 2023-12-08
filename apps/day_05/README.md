# Advent of Code 2023, Day 5

#### @aadmaa Learns Elixir
Problem descriptions are [here](https://adventofcode.com/2023/day/5), and summarized in script docs.

## Test

AoC provided sample data and an expected answer. Tests are created against that data prior to running the code against the "real" data.
```
mix test
```

## Run

```
iex

c "lib/day05.ex"
Day05.main("data/maindata.txt")
# Result: 

c "lib/day05b.ex"
Day05B.main("data/maindata.txt")
# Result: 
```

## Notes
Part "B" is nice because it requires one to track and split ranges of valid values, instead of individual values. I initially had some error in my splitting mechanism, and it didn't cause my small, test data set to give the wrong answer - but gave me a bad answer for the main set.

To find it I wanted to test my function to transform a range of seeds from A-B by one step of one transform (src, dest and length). This should always result in 1-3 new ranges, depending on whether the seeds extend to the left or to the right of the transformed range; or are all covered.

To check this I wanted to do some testing, and I wanted to compare whether lists of maps are equal. I could have sorted them manually and compared them, but that's boring, so instead I created a new sub-app to perform deep comparison of objects in Elixir, with the option to include Maps, and also to be sort-agnostic for lists. 

That is the Comparison.is_equal() utility in apps/common. There must be a robust Elixir library that does this somewhere but I didn't find it. 

As a library utility it is missing some features one would expect for such a tool, but it was super hand for my tests -- which showed me quickly where the problem was. Missing a "minus one" from one of the ranges I was producing. 

I also learned: 

- There's no built-in way to test private functions in Elixir. (That is annoying - clearly this is an instance where one would not want the range-splitting function to be included in an external API; but you also would want to keep your tests.)
- If you want to run a test of an umbrella app function that includes a library from another App, you have to run the test from the root of the project
- mix test options to run one test at a time. You can use the "--only" flag but it still shows you all the tests it did NOT run, making it hard to see your results in the output. Instead you can just name the file to test, like:
``` 
mix test apps\day_05\test\day05b_test.exs
```

