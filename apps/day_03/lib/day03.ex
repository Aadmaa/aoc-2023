defmodule Day03 do
  @moduledoc """
  Sum the value of numbers that are adjacent to symbols, including diagonally or above/below

  Refactored during Task B, because I learned how to use Stream.chunk_every
  which greatly simplifies things
  """


  # i is the index of the current line
  # line is the value of the current line
  # data_map is the entire map, with key=index, and value=line for all lines
  defp get_value([previous_line, line, next_line]) do

    # first get any number on the line itself
    line_target_locations = Regex.scan(~r/\d+/, line, return: :index)
    line_target_values = Regex.scan(~r/\d+/, line)

    # Locations ex: [[{0, 2}], [{9, 3}]]
    #     where the first number is the index and the second is the length
    #     careful b/c index isn't necessarily actual character length - it's byte length
    #     but that should be the same for this problem
    # Values ex:  [["35"], ["633"]]

    result =
      Enum.reduce(line_target_values, {0, 0}, fn [val_string], {value_index, acc_value} ->
        # acc value is {index, value}

        # if there a symbol right before or after on the same line
        # e.g., {9, 3}
        [{target_start, target_length}] = Enum.at(line_target_locations, value_index)
        symbol_seach_start = max(target_start - 1, 0)
        # One before, and one after
        # Note that if it starts at the beginning, there won't be 1 character before
        symbol_search_length = target_length + 1 + (target_start - symbol_seach_start)

        text_to_search =
          String.slice(previous_line, symbol_seach_start, symbol_search_length) <>
            String.slice(line,        symbol_seach_start, symbol_search_length) <>
            String.slice(next_line,   symbol_seach_start, symbol_search_length)

        # If there's a neighboring symbol, we will add the value of the number (val_string) to the accumulating result
        added_value = if Regex.match?(~r/[^.\d]/, text_to_search) do
          String.to_integer(val_string)
        else
          0
        end

        {value_index + 1, acc_value + added_value}

      end)
      |> elem(1)

      result

  end


  defp get_value_from_triplet(triplet) do
    get_value(triplet)
  end


  # main procedure
  def main(filename) do

    file_stream = File.stream!(Path.absname(filename))

    result =
      Stream.concat([[""], file_stream, [""]])
      |> Stream.map(&String.trim/1)
      |> Stream.chunk_every(3, 1, :discard)
      |> Enum.to_list
      |> Enum.reduce(0, fn triplet, acc -> acc + get_value_from_triplet(triplet) end)

    result

  end
end

# Maindata returned 532331, which AoC accepted as the CORRECT answer
