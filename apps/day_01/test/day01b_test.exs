defmodule Day01BTest do
  use ExUnit.Case
  doctest Day01B

  test "gets right answer for Part B with test dataset 2" do
    assert Day01B.main("data/testdata_2.txt") == 281
  end
end
