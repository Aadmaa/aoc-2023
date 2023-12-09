defmodule Day06BTest do
  use ExUnit.Case
  doctest Day06B

  import Common.LogUtils

  test "gets the right answer with test data (b)" do
    # 288 = (4 * 8 * 9)
    assert Day06B.main("data/testdata.txt") == 71503
  end
end
