defmodule Day02BTest do
  use ExUnit.Case
  doctest Day02B

  test "gets the right answer with test data (b)" do
    assert Day02B.main("data/testdata.txt") == 2286
  end
end
