defmodule Day08Shared do


  # Select direction indicator based on where we are on the cycle
  # Returns :left" or :right
  def select_direction(directions, counter, cycle) do
    index = rem(counter, cycle)
    d = Enum.at(directions, index)
    d in ["L","R"] or raise("Unexpected value for direction: #{d}")
    if d == "L", do: :left, else: :right
  end


  # Starting point - we know this because it has no accumulator yet
  # Create accumulator and get the "directions"
  def map_data([head | tail]) do
    directions = String.graphemes(String.trim(head))
    acc = %{
      directions:  directions,
      map: %{},
      # Cache the length of the directions array
      cycle: length(directions)
    }
    map_data( tail, acc )
  end

  defp proc_dataline(line, acc) do
    [ key, left, right ] = String.split(line, ["=", "(", ")", ","])
    |> Enum.filter(&(String.trim(&1) != ""))
    |> Enum.map(&String.trim(&1))

    # Map.put_new(acc, key,)
    put_in(acc, [:map, key],  %{ left: left, right: right })
  end

  defp map_data([head | tail], acc) do
    acc = cond do
      # Skip any blank lines
      String.trim(head) == "" -> acc
      true -> proc_dataline(head, acc)
      end
    map_data( tail, acc )
  end

  defp map_data([], acc) do
    acc
  end


end
