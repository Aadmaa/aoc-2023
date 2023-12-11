defmodule Day08BTest do
  use ExUnit.Case
  doctest Day08B

  test "gets the right answer with test data (b)" do
    assert Day08B.main("data/testdata_b.txt") == 6
  end
end
