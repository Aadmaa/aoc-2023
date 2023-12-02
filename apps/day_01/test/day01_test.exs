defmodule Day01Test do
  use ExUnit.Case
  doctest Day01

  test "gets right answer for Part A with test dataset" do
    assert Day01.main("data/testdata_1.txt") == 142
  end
end

# For example:
# 1abc2
# pqr3stu8vwx
# a1b2c3d4e5f
# treb7uchet
# In this example, the calibration values of these four lines are 12, 38, 15, and 77. 
# Adding these together produces 142.