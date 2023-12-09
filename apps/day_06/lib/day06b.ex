defmodule Day06B do
  import Common.LogUtils

  # Gets a list of integers from a string
  def string_to_int(str) do
    str
    |> String.split(":")
    |> Enum.at(1)
    |> String.replace(" ", "")
    |> String.to_integer()
  end

  def calculate_distance(duration, acceleration_seconds) do
    as = acceleration_seconds
    as * (duration - as)
  end

  defp which_way_is_uphill(duration, x_point) do
    y_point = calculate_distance(duration, x_point)
    y_right = calculate_distance(duration, x_point + 1)

    cond do
      y_right > y_point -> :right
      true -> :left
    end
  end

  # Note that race "duration" is a constant, as is y_target (which is the record distance)
  defp find_where_x_exceeds_target_while_increasing(duration, y_target, {x_left, x_right}) do
    if x_right > duration do
      raise "x_right should not be higher than duration"
    end

    if x_left < 0 do
      raise "x_left should not be negative"
    end

    y_left = calculate_distance(duration, x_left)
    y_left_plus_1 = calculate_distance(duration, x_left + 1)

    cond do
      y_left > y_target ->
        nil

      # The target y occurs between x_left and one above it. So we want the one above it.
      y_left_plus_1 > y_left and y_left_plus_1 > y_target ->
        x_left + 1

      x_left + 1 >= x_right ->
        # There is no answer in the range
        nil

      true ->
        x_halfway = x_left + max(1, round((x_right - x_left) / 2))
        direction = which_way_is_uphill(duration, x_halfway)

        result =
          if direction == :left do
            find_where_x_exceeds_target_while_increasing(duration, y_target, {x_left, x_halfway})
          else
            find_where_x_exceeds_target_while_increasing(duration, y_target, {x_halfway, x_right})
          end

        # Try the other side if needed
        cond do
          result != nil ->
            result

          direction == :left ->
            find_where_x_exceeds_target_while_increasing(duration, y_target, {x_halfway, x_right})

          direction == :right ->
            find_where_x_exceeds_target_while_increasing(duration, y_target, {x_left, x_halfway})
        end
    end
  end

  defp find_where_x_exceeds_target_while_decreasing(duration, y_target, {x_left, x_right}) do
    if x_right > duration do
      raise "x_right should not be higher than duration"
    end

    if x_left < 0 do
      raise "x_left should not be negative"
    end

    y_right = calculate_distance(duration, x_right)
    y_right_minus_1 = calculate_distance(duration, x_right - 1)

    cond do
      y_right > y_target ->
        nil

      y_right_minus_1 > y_target ->
        x_right - 1

      x_left + 1 >= x_right ->
        # There is no answer in the range
        nil

      true ->
        x_halfway = x_left + max(1, round((x_right - x_left) / 2))
        direction = which_way_is_uphill(duration, x_halfway)

        result =
          if direction == :left do
            find_where_x_exceeds_target_while_decreasing(duration, y_target, {x_halfway, x_right})
          else
            find_where_x_exceeds_target_while_decreasing(duration, y_target, {x_left, x_halfway})
          end

        # Try the other side if needed
        cond do
          result != nil ->
            result

          direction == :left ->
            find_where_x_exceeds_target_while_decreasing(duration, y_target, {x_left, x_halfway})

          direction == :right ->
            find_where_x_exceeds_target_while_decreasing(duration, y_target, {x_halfway, x_right})
        end
    end
  end

  def count_ways_to_beat_record(duration, record_y) do
    rez_left = find_where_x_exceeds_target_while_increasing(duration, record_y, {0, duration})
    rez_right = find_where_x_exceeds_target_while_decreasing(duration, record_y, {0, duration})

    logg("Leftmost winning seconds=#{rez_left}, Rightmost=#{rez_right}")

    rez_right - rez_left + 1
  end

  defp process_race([times_str, distances_str]) do
    duration = string_to_int(times_str)
    record_distance = string_to_int(distances_str)
    count_ways_to_beat_record(duration, record_distance)
  end

  @doc """
  main
  """
  def main(filename) do
    file_stream = File.stream!(Path.absname(filename))

    file_stream
    # Remove leading or trailing spaces
    |> Stream.map(&String.trim/1)
    # Replace any multiple spaces with single spaces
    |> Stream.map(&String.replace(&1, ~r/\s+/, " "))
    |> Stream.map(&IO.inspect/1)
    |> Enum.to_list()
    |> process_race
  end
end

# "Time: 54 94 65 92"
# "Distance: 302 1476 1029 1404"
# result -> 42550411 - correct=
