defmodule Day08B do
  @moduledoc """
  Documentation for `Day08B`.

  Examples
  iex

  c "../common/lib/log_utils.ex"
  c "../common/lib/prime_factors.ex"
  c "lib/day08shared.ex"
  c "lib/day08b.ex"
  Day08B.main("data/testdata_b.txt")

  TO do this faster, we can first look at each run individually, and determine all the
  "counter" values that get us to a spot that ends in "Z"
  """

##  import Common.PrimeFactors
  import Common.LogUtils
  import Day08Shared

  defp get_initial_locations(map) do
    map
    |> Enum.map(fn {k, _v} -> if String.last(k) == "A", do: k, else: nil end)
    |> Enum.filter(&(&1 != nil))
  end

  defp get_next_location(map, location, direction) do
      get_in(map,[location, direction])
  end



  defp cached_value(visited, location, direction, directions_index) do
    # visited = %{ "SRD" => %{ directions_index =>  %{left: true, right: true }}}

    val = get_in(visited, [location, directions_index, direction])

    already_visited = if val == nil or val == false, do: false, else: true

    cond do
      already_visited == true -> { true,  visited}
      true ->
       { false, map_put(visited, [location, directions_index, direction], true) }
    end
  end

  # Endpoints have "counter" values [4, 6, 19] ...
  defp get_endpoint_counters(data, counter, visited, index_location, current_location, endpoints) do

    next_direction = select_direction(data.directions, counter, data.cycle)
    # Have I already gotten the next location from here?
    # Note that this is based on
    #   current location
    #   next direction

    turn_index =  rem(counter, data.cycle)

    #   rem(counter, cycle) - which tells use where we are in the directions list
    { already_visited, updated_visited_cache } = cached_value(visited, current_location, next_direction, turn_index)

    if already_visited do
      endpoints
    else
      next_loc = get_next_location(data.map, current_location, next_direction)

      is_end = String.last(next_loc) === "Z"

      updated_endpoints = if is_end , do: [counter + 1 | endpoints], else: endpoints

      get_endpoint_counters(data, counter+1, updated_visited_cache,
        index_location, next_loc, updated_endpoints)
    end
  end

  # Start here...
  defp get_endpoint_counters(data, start_location) do
                      #  (data, counter, visited, index_location, current_location, endpoints)
    get_endpoint_counters( data,      0,     %{}, start_location, start_location,   [])
  end

  def get_data(filename) do
    file_stream = File.stream!(Path.absname(filename))

    file_stream
    |> Enum.to_list()
    |> map_data
  end

  # Get the value to use for a particular set of ending points
  def get_val_for_set(endpoints, startpoints) do

    my_set = Enum.map(0..length(endpoints)-1, fn index ->
      possible_endpoints = Enum.at(endpoints, index)
      selected_index = Enum.at(startpoints, index)-1
      Enum.at(possible_endpoints, selected_index)
    end)

    # Get the Prime factors for each item, put them all together, deduplicate them,
    # and multiply them all together.
    # That should give the answer, because all will be hitting an endpoint
    # on that beat.
    my_set
    |> Enum.map(&Common.PrimeFactors.of/1)
    |> List.flatten
    |> Enum.uniq
    |> Enum.reduce(fn val, acc -> acc * val end)

  end


  def increment_startpoints(startpoints, maxpoints, index) do
    cond do
      index < 0 -> startpoints
      Enum.at(startpoints, index) >= Enum.at(maxpoints, index) -> increment_startpoints(startpoints, maxpoints, index - 1)
      true ->
        Enum.with_index(startpoints, 0)
        |> Enum.map(fn { val, i} -> if i == index, do: val+1, else: val end)
    end
  end

  def increment_startpoints(startpoints, maxpoints) do
    increment_startpoints(startpoints, maxpoints, 4)
  end

  # If there are this many possible counts-to-win
  # [1, 2, 1, 6]
  # 1 * 2 * 1 * 6 ways to win
  # And we can select them
  # 1, 1, 1, 1
  # 1, 1, 1, 2
  # 1, 1, 1, ...6
  # 1, 2, 1, 1
  # 1, 2, 1, 2
  # 1, 2, 1, ...6
  # Like counting, we add one to the right
  def get_val(endpoints) do

    # If we pair up all the different items from each list
    total_ways_to_succeed = Enum.reduce(endpoints, 1, fn val, acc ->
      acc * length(val)
    end)

    startpoints = Enum.map(endpoints, fn _ -> 1 end)       # current value for each start point
    maxpoints = Enum.map(endpoints, fn v -> length(v) end)  # max value for each start point

    { _, final_val }  = Enum.reduce(1..total_ways_to_succeed, {startpoints, nil}, fn _, { startpoints, val } ->
      new_val = get_val_for_set(endpoints, startpoints)
      # Keep the lowest non-nil value
      use_val = if val == nil, do: new_val, else: min(val, new_val)
      { increment_startpoints(startpoints, maxpoints) , use_val }
    end)

    final_val
  end



  def proc_all(data) do
    endpoints =
      # e.g., ["11A", "22A"]
      get_initial_locations(data.map)
      |> Enum.map(fn start_loc ->
          %{
            start_loc: start_loc,
                        #                    (data, counter, visited,   index_location, current_location, endpoints)
            endpoints:  get_endpoint_counters(data, start_loc)
          }
      end)
      |> Enum.map(fn val -> val.endpoints end)

    get_val(endpoints)

  end


  def main(filename) do
    file_stream = File.stream!(Path.absname(filename))

    file_stream
    |> Enum.to_list()
    |> map_data
    |> proc_all

  end
end

# Got 16187743689077 which is the correct answer
