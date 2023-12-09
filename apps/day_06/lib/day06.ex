defmodule Day06 do

  @moduledoc """
  Documentation for `Day06`.

  Examples
  iex

  c "../common/lib/utils.ex"
  c "lib/day06.ex"
  Day06.main("data/testdata.txt")

  """

  # Gets a list of integers from a string
  def string_to_int_list(str) do
    String.split(str," ")
    |> Enum.map(&(String.trim(&1)))
    |> Enum.filter(fn v -> v != "" and String.match?(v, ~r/^[\d]+$/) end)
    |> Enum.map(fn v -> String.to_integer(v) end)
  end

  # For the period of acceleration,
  # Distance added in each new second will be 1 more than the previous second,
  # and total distance is each new distance, summed up. You can sum them with the sum of series method where
  # you pair the first and last items, and mutliply by the number of pairs. So each new distance while accelerating is
  # the duration minus 1. The sum for the who period of acceleration (with sum of series method) is
  # (final_new_distance + 1)/2 and the final new distance is just the acceleration duration minus one:
  #
  # distance_during_acc = acceleration_seconds * (acceleration_seconds+1) / 2
  # which is the same as the sum of the series 1+2+3+4+5...
  #
  # Then the final velocity is acceleration * time = acceleration_seconds
  # And the final distance is final-v * remaining-t which is acceleration_seconds * (duration - acceleration_seconds)
  #
  # if we call acceleration_seconds "S" then
  # Distance = S*(S + 1)/2 + S*(DURATION - S)


  def calculate_distance(duration, acceleration_seconds) do
    as = acceleration_seconds
    as*(duration - as)
  end

 # This is of course a naive way to play, going one by one.
def count_ways_to_beat_record(duration, record_distance) do
  Enum.reduce(1..duration, 0, fn val, acc ->
    dist = calculate_distance(duration, val)
    if dist > record_distance  do
      # logg("Win, duration=#{duration} accel=#{val}  dist=#{dist} (record: #{record_distance})  rez=#{acc} ")
      acc + 1
    else
      # logg("LOSE, duration=#{duration} accel=#{val}  dist=#{dist} (record: #{record_distance})  rez=#{acc}")
      acc
    end
  end)
end

  # This is of course a naive way to play, going one by one.
  defp process_all_races([times_str, distances_str]) do
    durations = string_to_int_list(times_str)
    record_distances = string_to_int_list(distances_str)

    for i <- 1..length(durations) do
      count_ways_to_beat_record(Enum.at(durations,i-1), Enum.at(record_distances,i - 1))
    end
  end

  @doc """
  main
  """
  def main(filename) do
    file_stream = File.stream!(Path.absname(filename))

    file_stream
    |> Stream.map(&String.trim/1)                         # Remove leading or trailing spaces
    |> Stream.map(&String.replace(&1, ~r/\s+/, " "))      # Replace any multiple spaces with single spaces
    |> Enum.to_list()
    |> process_all_races
    |> Enum.reduce(1, fn val, acc ->
        acc * val
      end)
  end

end

# This gives 1195150 which is the right answer
