defmodule Day07BTest do
  use ExUnit.Case
  doctest Day07B

  test "gets the right answer with test data (b)" do
    assert Day07B.main("data/testdata.txt") == 5905
  end
end
