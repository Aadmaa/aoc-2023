defmodule Day03BTest do
  use ExUnit.Case
  doctest Day03B

  test "get correct answer in problem (3b) for sample data" do
    assert Day03B.main("data/testdata.txt") == 467835
  end
end

# 467835
