defmodule Day03B do
  @moduledoc """
  Find pairs of numbers that are adjacent to a "*", including diagonally.
  Multiply the pairs together and sum them.
  Ignore non-pairs.
  """

  # Returns numeric locations as an array of [{ index1, length1 }, { index2, length2 }, ...]
  defp get_numeric_locations(str) do
    Regex.scan(~r/\d+/, str, return: :index) |> Enum.map(fn [v] -> v end)
  end

  # Returns numeric values as an array [value1, value2 ...]
  defp get_numeric_values(str) do
    Regex.scan(~r/\d+/, str) |> Enum.map(fn [v] -> String.to_integer(v) end)
  end

  # Returns star locations as an array of [ index1, index2, ...]
  defp get_star_locations(str) do
    # Note that all * should be length 1, so pattern match [{index, 1}] extracts the index only
    Regex.scan(~r/\*/, str, return: :index) |> Enum.map(fn [{index, 1}] -> index end)
  end

  defp index_in_range(index, start_range, range_length) do
    index >= start_range and index < start_range + range_length
  end

  # For a given star index, see if it is adjacent to a number on the line represented with
  defp get_adjacent_numerics(star_index, line) do
    numeric_locations = get_numeric_locations(line)
    numeric_values = get_numeric_values(line)

    Enum.reduce(numeric_locations, {0, []}, fn {numeric_loc_start, numeric_loc_length},
                                               {index, acc} ->
      if index_in_range(star_index - 1, numeric_loc_start, numeric_loc_length) or
           index_in_range(star_index, numeric_loc_start, numeric_loc_length) or
           index_in_range(star_index + 1, numeric_loc_start, numeric_loc_length) do
        the_number = Enum.at(numeric_values, index)

        {index + 1, [the_number | acc]}
      else
        {index + 1, acc}
      end
    end)
    |> elem(1)
  end

  # i is the index of the current line
  # line is the value of the current line
  # data_map is the entire map, with key=index, and value=line for all lines
  defp get_value([prev, line, next]) do
    star_locations = get_star_locations(line)

    # Look at each line_star_locations and collect any numeric values that touch it
    result =
      Enum.reduce(star_locations, 0, fn star_index, acc ->
        a = get_adjacent_numerics(star_index, prev)
        b = get_adjacent_numerics(star_index, line)
        c = get_adjacent_numerics(star_index, next)

        my_matches = a ++ b ++ c

        # Return the value: either multiply two, or ignore any other number of "parts"
        acc +
          if length(my_matches) == 2 do
            [match1, match2] = my_matches
            match1 * match2
          else
            0
          end
      end)

    result
  end

  # main procedure
  def main(filename) do
    file_stream = File.stream!(Path.absname(filename))

    Stream.concat([[""], file_stream, [""]])
    |> Stream.map(&String.trim/1)
    |> Stream.chunk_every(3, 1, :discard)
    |> Enum.to_list()
    |> Enum.reduce(0, fn triplet, acc -> acc + get_value(triplet) end)
  end
end

# Maindata returned 82301120, which AoC accepted as the CORRECT answer
