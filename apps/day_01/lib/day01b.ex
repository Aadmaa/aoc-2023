defmodule Day01B do
  @moduledoc """
  `Day01B` - Get the first and last digits from each line,
  convert them to integers and total them.
  If there's just one digit it gets used twice.

    Same data, but now we also
    interpret one two three four five six seven eight nine as digits


  """

  defp my_map do
    %{
      "one" => 1,
      "two" => 2,
      "three" => 3,
      "four" => 4,
      "five" => 5,
      "six" => 6,
      "seven" => 7,
      "eight" => 8,
      "nine" => 9,
      "1" => 1,
      "2" => 2,
      "3" => 3,
      "4" => 4,
      "5" => 5,
      "6" => 6,
      "7" => 7,
      "8" => 8,
      "9" => 9,
      "0" => 0
    }
  end

  # Extract either the left or the rightmost digit
  defp get_digit(line, left_or_right) do
    number_map = my_map()
    keys = Map.keys(number_map)

    # First we will get a list of each "digit" that is found in the string, and it's leftmost starting location
    # E.g., [{3, 9}, {11, 8}] means a 9 was found at index 3, and an 8 was found at index 11
    # Note that we do it backwards for the rightmost search
    Enum.map(keys, fn key ->
      match_key =
        case left_or_right do
          "left" -> key
          "right" -> String.reverse(key)
          _ -> raise("Invalid value: #{left_or_right}")
        end

      match_line =
        case left_or_right do
          "left" -> line
          "right" -> String.reverse(line)
          _ -> raise("Invalid value: #{left_or_right}")
        end

      case :binary.match(match_line, match_key) do
        :nomatch -> nil
        {index, _value} -> {index, number_map[key]}
      end
    end)
    # Get rid of the unmatched digits
    |> Enum.filter(fn val -> val !== nil end)
    # Get the tuple with the lowest index
    |> Enum.min_by(fn {index, _value} -> index end)
    # return it's corresponding value
    |> elem(1)
  end

  # Extract the 2 digit number from the line
  defp get_digits(line) do
    a = get_digit(line, "left")
    b = get_digit(line, "right")
    a * 10 + b
  end

  # Recursive function to add the values from each line
  defp countem([]), do: 0

  defp countem([head | tail]) do
    get_digits(head) + countem(tail)
  end

  # main procedure
  def main(filename) do
    result =
      File.stream!(Path.absname(filename))
      |> Stream.map(&String.trim/1)
      |> Enum.to_list()
      |> countem

    IO.puts("result: #{result}")

    result
  end
end

# answer: 55291
