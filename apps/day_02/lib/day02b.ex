defmodule Day02B do
  @moduledoc """
  `Day02B` - Determine the max number of cubes we see, for each color, within each game.
  Then multiply those numbers together, for each game.
  The sum these values for all games.
  There is one Game on each line.
  """

  # Helper for cube_value providing the max for a particular
  # color among multiple runs of the same Game
  defp max_for_color(run_items, color) do
    Enum.map(run_items, fn [val_str, col] ->
      case col do
        ^color -> String.to_integer(val_str)
        _ -> 0
      end
    end)
    |> Enum.max()
  end

  # Returns either 0 or the value of the ID (if all runs are legal)
  defp cube_value(line) do
    # IO.puts(line)

    [game_text, run_text] =
      String.split(line, ":")
      |> Enum.map(&String.trim/1)

    ["Game", _id] = String.split(game_text, " ")

    run_items =
      String.split(run_text, [";", ","])
      |> Enum.map(&String.trim/1)
      |> Enum.map(fn x ->
        String.split(x, " ")
      end)

    # Calculate and return the result
    blue = max_for_color(run_items, "blue")
    red = max_for_color(run_items, "red")
    green = max_for_color(run_items, "green")
    cube = blue * red * green

    # IO.puts("cube: #{cube}  blue: #{blue} red: #{red} green: #{green}")

    cube
  end

  # Recursive function to add the IDs from each line
  defp countem([]), do: 0

  defp countem([head | tail]) do
    cube_value(head) + countem(tail)
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

# answer: 83435
