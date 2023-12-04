defmodule Day03 do
  @moduledoc """
  Sum the value of numbers that are adjacent to symbols, including diagonally or above/below
  """

  # i is the index of the current line
  # line is the value of the current line
  # data_map is the entire map, with key=index, and value=line for all lines
  defp get_value(i, line, data_map) do
    # first get any number on the line itself
    line_target_locations = Regex.scan(~r/\d+/, line, return: :index)
    line_target_values = Regex.scan(~r/\d+/, line)

    previous_line =
      Map.fetch(data_map, i - 1)
      |> case do
        {:ok, val} -> val
        _ -> ""
      end

    next_line =
      Map.fetch(data_map, i + 1)
      |> case do
        {:ok, val} -> val
        _ -> ""
      end

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


        # IO.puts(" val_str: #{val_string}")
        # IO.puts("   prev: #{previous_line}")
        # IO.puts("   line: #{line}")
        # IO.puts("   next: #{next_line}")

        text_to_search =
          String.slice(previous_line, symbol_seach_start, symbol_search_length) <>
            String.slice(line,        symbol_seach_start, symbol_search_length) <>
            String.slice(next_line,   symbol_seach_start, symbol_search_length)

        # IO.puts("   text_to_search: #{text_to_search}")

        # If there's a neighboring symbol, we will add the value of the number (val_string) to the accumulating result
        added_value = if Regex.match?(~r/[^.\d]/, text_to_search) do
          # IO.puts("      keep: #{val_string}")
          String.to_integer(val_string)
        else
          # IO.puts("   DISCARD: #{val_string}")
          0
        end

        {value_index + 1, acc_value + added_value}

      end)
      |> elem(1)

      # IO.puts("line result: #{result}")

      result

  end

  # main procedure
  def main(filename) do
    data_map =
      File.stream!(Path.absname(filename))
      |> Stream.map(&String.trim/1)
      |> Stream.with_index()
      # |> Stream.each(&IO.inspect/1)
      |> Enum.to_list()
      |> Enum.reduce(%{}, fn {line, i}, acc -> Map.put(acc, i, line) end)

    Enum.reduce(data_map, 0, fn {i, line}, acc -> acc + get_value(i, line, data_map) end)

  end
end

# Maindata returned 532331, which AoC accepted as the CORRECT answer
