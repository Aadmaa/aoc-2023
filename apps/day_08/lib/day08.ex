defmodule Day08 do
  @moduledoc """
  Documentation for `Day08`.

  Examples
  iex

  c "../common/lib/log_utils.ex"
  c "lib/day08shared.ex"
  c "lib/day08.ex"
  Day08.main("data/testdata.txt")

  We import into a data structure like this
  %{
    counter: 0,
    cycle: 3,
    directions: ["L", "L", "R"],
    map: %{
      "AAA" => %{left: "BBB", right: "BBB"},
      "BBB" => %{left: "AAA", right: "ZZZ"},
      "ZZZ" => %{left: "ZZZ", right: "ZZZ"}
    }
  }

  """

  import Day08Shared

  # counter is 0 after 0 turns have been made - counts the turns
  # location is an index in the map. like JJJ
  def run_maze(data, counter \\ 0, location \\ "AAA") do
    if location == "ZZZ" do
      counter
    else
      # Note: if we had arbitrary data we'd want to ensure that we don't get an infinite loop
      # One way to do that is to cache {location, next_direction}. If that repeats, we should
      # just raise an error
      next_direction = select_direction(data.directions, counter, data.cycle)
      next_location = get_in(data,[:map,location,next_direction])
      run_maze(data, counter+1, next_location)
    end
  end


  def main(filename) do
    file_stream = File.stream!(Path.absname(filename))

    file_stream
    |> Enum.to_list()
    |> map_data
    |> run_maze

  end
end

# Got 14257 which is the correct answer
