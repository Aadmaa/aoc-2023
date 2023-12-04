defmodule Day04BTest do
  use ExUnit.Case
  doctest Day04B

  test "gets the right answer with test data (b)" do
    assert Day04B.main("data/testdata_b.txt") == 30
  end
end
