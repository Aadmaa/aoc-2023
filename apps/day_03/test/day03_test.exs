defmodule Day03Test do
  use ExUnit.Case
  doctest Day03

  test "get correct answer in problem (3a) for sample data" do
    assert Day03.main("data/testdata.txt") == 4361
  end
end

# 467835
