defmodule Day08Test do
  use ExUnit.Case
  doctest Day08

  test "gets the right answer with test data (a)" do
    assert Day08.main("data/testdata.txt") == 6
  end
end
