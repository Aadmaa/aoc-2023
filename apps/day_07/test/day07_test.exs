defmodule Day07Test do
  use ExUnit.Case
  doctest Day07

  test "gets the right answer with test data (a)" do
    assert Day07.main("data/testdata.txt") == 6440
  end
end
