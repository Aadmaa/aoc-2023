defmodule Day04 do
  @moduledoc """
  `Day04`
  Left hand list of numbers are Winners.
  Right hand list are My Guesses.
  Count the correct guesses on each line
  If more than zero, calculate 2^(correct - 1), e.g., 2^1 = 1 for 1 right, or 2^3 = 8 for 4 right
  Sum these values for all lines
  """

  defp row_value(winners, mine) do

    len = length(
      Enum.filter(mine, fn item ->
        Enum.find(winners, &(&1 == item)) != nil
      end)
    )

    # Return 2^ (length-1) or 0 if length is 0
    if len > 0, do: 2 ** (len - 1), else: 0

  end


  def main(filename) do
    file_stream = File.stream!(Path.absname(filename))

    file_stream
    |> Stream.map(&String.trim/1)
    # Replace multiple spaces with just one space (eg "x    y" => "x y")
    |> Stream.map(&String.replace(&1, ~r/\s+/, " "))
    # |> Enum.map(&IO.inspect/1)
    |> Stream.map(&String.split(&1, ~r/[:|]/))
    |> Stream.map(fn [_game, winners, mine] -> [String.trim(winners), String.trim(mine)] end)
    |> Stream.map(fn [winners, mine] -> [String.split(winners, " "), String.split(mine, " ")] end)
    # Now we have two lists of strings that are the winners. Let's keep the ones on the right that match the left
    |> Stream.map(fn [winners, mine] -> row_value(winners, mine) end)
    |> Enum.sum

  end
end

# This returns 32609, which is the right answer
