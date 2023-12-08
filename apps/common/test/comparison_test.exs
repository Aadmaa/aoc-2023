defmodule ComparisonTest do
  use ExUnit.Case
  doctest Common.Comparison

  import Common.Comparison

  test "compares scalars" do
    assert is_equal(2, 2)
    assert is_equal(2, 2.0)
    assert !is_equal(2, 3)
    assert !is_equal(2, 2.0, [strict: true])
    assert is_equal({"a", "b"}, {"a", "b"})
    assert !is_equal({"a", "b"}, {"b", "a"})
    assert is_equal(false, false)
    assert !is_equal(false, "")
  end


  test "compares maps" do
    assert is_equal(%{a: "AAA", b: "BBB"}, %{a: "AAA", b: "BBB"})
    assert !is_equal(%{a: "AAA", b: "BBB"}, %{a: "AAA", b: "XXX"})
    assert !is_equal(%{a: "AAA", b: "BBB"}, %{a: "AAA", c: "BBB"})
    assert !is_equal(%{a: "AAA", b: "BBB"}, %{a: "AAA"})

    assert is_equal(%{a: "AAA", b: 4}, %{a: "AAA", b: 4.0})
    assert !is_equal(%{a: "AAA", b: 4}, %{a: "AAA", b: 4.0}, [strict: true])
  end


  test "compares lists" do
    assert is_equal([12, 45, "x"], [12, 45, "x"])
    assert !is_equal([12, 45, "x"], [12, 45, "YYY"])
    # By default, lists are not sorted before comparing them
    assert !is_equal([45, 12, "x"], [12, 45, "x"])
    assert is_equal([45, 12, "x"], [12, 45, "x"], [list_order_irrelevant: true])
  end

  test "compares lists with nested maps" do
    # Should work if they are all in the same order
    assert is_equal(
      [%{a: 12, b: 15}, %{a: 11, b: 12} ],
      [%{a: 12, b: 15}, %{a: 11, b: 12} ]
    )
    # Should not work with list out of order
    assert !is_equal(
      [%{a: 12, b: 15}, %{a: 11, b: 12} ],
      [%{a: 11, b: 12}, %{a: 12, b: 15} ]
    )

  end


end
