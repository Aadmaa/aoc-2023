defmodule Day05BTest do

  use ExUnit.Case
  @tag awawaw: true

  doctest Day05B

  import Common.Comparison

  test "gets the right answer with test data (b)" do
    assert Day05B.main("data/testdata.txt") == 46
  end

  test "does proc_seed_ranges_through_one_step_range correctly" do

    testcases = [
      # None affected
      %{ xform_step: %{ dest: 16, src: 29, len: 5 }, seeds: [%{A: 15, B: 25}], expect_untouched: [%{A: 15, B: 25}],  expect_transformed: []},
      # All affected: Backwards 4 for affected 14-10
      %{ xform_step: %{ dest: 10, src: 14, len: 20 }, seeds: [%{A: 15, B: 25}],
        expect_untouched: [],  expect_transformed: [%{A: 15-(14-10), B: 25-(14-10)}]},
      # All affected, right on the edges
      %{ xform_step: %{ dest: 10, src: 15, len: 20 }, seeds: [%{A: 15, B: 25}],
        expect_untouched: [],  expect_transformed: [%{A: 15-(15-10), B: 25-(15-10)}]},
      # Unaffected on the left, all affected on the right
      %{ xform_step: %{ dest: 10, src: 15, len: 20 }, seeds: [%{A: 12, B: 25}],
        expect_untouched: [%{A: 12, B: 14}],  expect_transformed: [%{A: 15-(15-10), B: 25-(15-10)}]},
      # Unaffected on the right, all affected on the left
      %{ xform_step: %{ dest: 10, src: 15, len: 20 }, seeds: [%{A: 16, B: 40}],
        expect_untouched: [%{A: 35, B: 40}],  expect_transformed: [%{A: 16-(15-10), B: 34-(15-10)}]},
      # Unaffected on both ends; the middle is all transformed
        %{ xform_step: %{ dest: 10, src: 15, len: 20 }, seeds: [%{A: 10, B: 40}],
        expect_untouched: [%{A: 35, B: 40}, %{A: 10, B: 14}],  expect_transformed: [%{A: 15-(15-10), B: 34-(15-10)}]},
    ]

    Enum.each(testcases, fn testcase ->
      %{ xform_step: xform_step, seeds: seeds, expect_untouched: expect_untouched, expect_transformed: expect_transformed } = testcase

      { untouched, transformed } = Day05B.proc_seed_ranges_through_one_step_range(xform_step, seeds)

      assert(is_equal(untouched, expect_untouched, [list_order_irrelevant: true]) )
      assert(is_equal(transformed, expect_transformed), [list_order_irrelevant: true] )
    end)


#    logg("untouched", untouched)
#    logg("transformed", transformed)
#    logg("untouched_found", untouched_found)
#    logg("transformed_found", transformed_found)

 #   untouched_found = Enum.any?(untouched, &(&1 == seeds_1))

#    Enum.each(seeds_1, fn seed -> Enum.any?(transformed, &(&1 == seeds_1)) end)



 #   assert(untouched_found and not transformed_found)

  end

end
