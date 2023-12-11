
# Credit: greggreg and Jose Valim
# Here: https://stackoverflow.com/questions/28587249/how-can-this-code-be-better-structured-in-elixir#28595616

defmodule Common.PrimeFactors do

  @doc "Calculates the unique prime factors of a number"
  def of(num) do
    prime_factors(num)
    |> Enum.uniq
    # |> Enum.filter(&(&1 != 1))
  end

  @doc """
  Calculates all prime factors of a number by finding a low factor
  and then recursively calculating the factors of the high factor.
  Skips all evens except 2.
  Could be further optimized by only using known primes to find factors.
  """
  def prime_factors(num , next \\ 2)
  def prime_factors(num, 2) do
    cond do
      rem(num, 2) == 0 -> [2 | prime_factors(div(num, 2))]
      4 > num          -> [num]
      true             -> prime_factors(num, 3)
    end
  end
  def prime_factors(num, next) do
    cond do
      rem(num, next) == 0 -> [next | prime_factors(div(num, next))]
      next + next > num   -> [num]
      true                -> prime_factors(num, next + 2)
    end
  end

end
