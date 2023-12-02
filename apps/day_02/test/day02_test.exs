defmodule Day02Test do
  use ExUnit.Case
  doctest Day02

  test "gets the right answer with test data (a)" do
    assert Day02.main("data/testdata.txt") == 8
  end
end
