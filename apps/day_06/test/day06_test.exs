defmodule Day06Test do
  use ExUnit.Case
  doctest Day06

  import Common.LogUtils


  test "gets the right answer with test data (a)" do
    # 288 = (4 * 8 * 9)
    assert Day06.main("data/testdata.txt") == 288
  end
end

# 71503
