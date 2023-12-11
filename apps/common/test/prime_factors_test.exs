defmodule PrimeFactorsTest do
  alias Common.PrimeFactors
  use ExUnit.Case
  doctest Common.PrimeFactors

  test "prime factors are correct" do
    numbers = [4, 15, 22, 100, 1000, 2398, 293487,
               32409850, 95810934857, 50_000_000]
    Enum.map(numbers, fn (num) ->
      assert num == Enum.reduce(PrimeFactors.prime_factors(num), &*/2)
    end)
  end


end
