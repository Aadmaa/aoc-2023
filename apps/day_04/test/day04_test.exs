defmodule Day04Test do
  use ExUnit.Case
  doctest Day04

  test "gets the right answer with test data (a)" do
    assert Day04.main("data/testdata.txt") == 13
  end
end
