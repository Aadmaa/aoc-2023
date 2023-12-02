defmodule Day02 do
  @moduledoc """
  `Day02` - Determine which games are possible, then sum their IDs,
  assuming max of 12 red cubes, 13 green cubes, and 14 blue cubes
  There is one Game on each line.
  """

  @max_r 12
  @max_g 13
  @max_b 14

  defp legal_run?(run_string) do

    is_legal = String.split(run_string, ",")
      |> Enum.map(&(String.trim/1))
      |> Enum.map(fn x -> 
          [num_str, color] = String.split(x) |> Enum.map(&(String.trim/1))
          num = String.to_integer(num_str)

          case color do 
            "green" -> num <= @max_g
            "red" -> num <= @max_r
            "blue" -> num <= @max_b
            _ -> raise("Invalid color value: #{color}")
          end

         end)
      |> Enum.reduce(true, fn legal, acc -> acc and legal end)
    
    is_legal
    
  end


  # Returns either 0 or the value of the ID (if all runs are legal)
  defp id_value(line) do
    # IO.puts(line)
    
    [game_text, run_text] = 
      String.split(line, ":") 
      |> Enum.map(&(String.trim/1))
    
    ["Game",id] = String.split(game_text, " ")
    
    runs = String.split(run_text, ";")
      |> Enum.map(&(String.trim/1))

    # E.g., runs = ["6 red, 1 blue, 3 green", "2 blue, 1 red, 2 green"]
    all_runs_legal? = Enum.map(runs, &legal_run?/1)
      |> Enum.reduce(true, fn legal, acc -> acc and legal end)

    if all_runs_legal? do
      String.to_integer(id)
    else
      0
    end

  end


  # Recursive function to add the IDs from each line
  defp countem([]), do: 0
  defp countem([head|tail]) do 
    id_value(head) + countem(tail)
  end

  # main procedure
  def main(filename) do
    result = File.stream!(Path.absname(filename), [:read]) 
      |> Stream.map(&String.trim/1)
      |> Enum.to_list()
      |> countem

    IO.puts("result: #{result}")

    result

  end
  
end

# answer: 2239