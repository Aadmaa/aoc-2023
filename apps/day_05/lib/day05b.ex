defmodule Day05B do
  @moduledoc """
  `Day05B - see description in AoC`

  The challenge: we can't deal with this as individual seeds because the main data ranges are really large.
  So instead of a seed we start with a big range. We can store it like this:
  [{
    A: 10,
    Z: 120   # This would happen for a seed pair (start, length) of (10, 110)
  },
  {
    A: 55,
    Z: 68
  }]
  Then we will run each one of those pairs through the top process, e.g. dest=52, src=50, len=48 and then
  the next one, but both times starting with the original pair ({79, 93}) for each of the process lines

  For a process like (52/50/38) the affected seeds range from 50 to 97, as follows
    50 = src
    97 = (src + len - 1)

  So now we need to split out range of 10-120 into three ranges:
    (a) 10-49
    (b) 50-97 which becomes (50 - dest) to (97 - dest) = -2 to 47
    (c) 98-120

  (b) can no longer be reprocessed in this step (e.g., "soil-to-fertilizer") but (a) and (b) are untouched
  so they get piped to the next triplet in the step. Any ranges that get transformed should get held in
  a group until the end of the step.

  After we run the ranges through all the triplets in a step, the untouched ranges are merged back with the
  transformed ranges, so we once again have an array of [{ A: ..., Z: ...}, { A: ..., Z: ...}, ...]

  This array is then piped to the next step (e.g., "fertilizer-to-water"), and so forth.

  At the end we just need the smallest "A" to get the minimum possible value
  """

  import Day05Shared


  # First we load data into this structure, then process
  # with "proc_data"
  # {
  #   seeds: [],
  #   xforms: {
  #    xform_name: @{
  #       values: [@{ dest, src, len }],
  #       step: integer
  #    }
  #   },
  #   current_xform: string,
  #   current_step: string
  # }


  # Takes "untouched" ranges and splits as needed
  # Returns ranges as { untouched, transformed }
  def proc_seed_ranges_through_one_step_range(%{ dest: dest, src: src, len: len }, seed_ranges) do

    Enum.reduce(seed_ranges, {[],[]} , fn seed_range, acc ->
      # For this seed range, see if we need to split it
      # src, dest, len
      # A, B is the seed range

      # affected_seeds range from src to (src + len - 1)
      # actual_right = (src + len - 1)

      { untouched, transformed } = acc

      %{A: a, B: b} = seed_range

      # affected_seeds range from src to (src + len - 1)
      actual_right = (src + len - 1)

      affected_left = cond do
        src > b -> nil
        src <= a -> a
        true -> src
      end

      affected_right = cond do
        actual_right < a -> nil
        actual_right <= b -> actual_right
        true -> b
      end

        if affected_left == nil or affected_right == nil do
            # The transform has no affect because it covers irrelevant ranges
            # So we return everything the same way we found it
            { untouched ++ [%{ A: a, B: b }] , transformed}
        else

          # (src - dest) is the transformation distance
          transformed_range = %{ A: affected_left - (src - dest), B: affected_right - (src - dest) }

          new_untouched = [
            # left, untouched range
            if affected_left > a do
              %{ A: a, B: affected_left - 1}
            else
              nil
            end,
            # right, untouched range
            if affected_right < b do
              %{ A: affected_right + 1, B: b }
            else
              nil
            end
          ]

          # logg("untouched.....", untouched)
          old_untouched = Enum.filter(untouched, fn val ->
            %{A: aaa, B: bbb} = val
            aaa != a or bbb != b
          end )

          all_untouched = Enum.concat(old_untouched, new_untouched) |> Enum.filter(&!is_nil(&1))

          # Return the new, untouched range(s) and the merged list of old and new transformed ranges
          { all_untouched, Enum.concat([transformed_range], transformed) }

        end


    end)

  end



  # This processes all transforms for a step, like, "fertilizer-to-water"
  # And returns the new list of seed ranges
  defp proc_ranges_one_step(data, initial_seed_ranges, step) do
    %{ xforms: xf } = data

    f = Map.filter(xf, fn { _key, val } -> val.step == step end)
    [name] = Map.keys(f)
    step_ranges = f[name][:values]

    # I have the initial seed ranges and the initial step ranges
    # I need the final seed ranges
    # So I need to loop over the step_ranges
    { untouched, transformed } = Enum.reduce(step_ranges,
      {initial_seed_ranges,[]},
      fn step_range, { untouched, transformed }  ->

      # And I need to loop over the seed ranges
      { new_untouched, new_transformed } = proc_seed_ranges_through_one_step_range(step_range, untouched )

      # Merge the previous and newly transformed ranges
      { new_untouched, Enum.concat(transformed, new_transformed) }

    end)

    # Merge the untouched and transformed, now that we are done with this stage
    Enum.concat(untouched, transformed)

  end


  # THis operates with data that has the :seed_ranges array added
  defp proc_all_steps(data) do
    step_count = data.current_step
    initial_seed_ranges = seeds_to_pairs(data.seeds)

    Enum.reduce(1..step_count, initial_seed_ranges, fn step, acc ->
         rez = proc_ranges_one_step(data, acc, step)
         rez
    end)
  end


  defp seeds_to_pairs(seeds) do
    seeds
      |> Enum.chunk_every(2,2)
      # Transform from start and length to start index (A) and end index(B)
      |> Enum.map(fn val -> %{ A: Enum.at(val, 0), B: Enum.at(val, 0) + Enum.at(val,1) - 1 } end)
  end


  def main(filename) do
    file_stream = File.stream!(Path.absname(filename))

    file_stream
    |> Stream.map(&String.trim/1)                         # Remove leading or trailing spaces
    |> Stream.map(&String.replace(&1, ~r/\s+/, " "))      # Replace any multiple spaces with single spaces
    |> Enum.to_list()
    |> map_data
    |> proc_all_steps
    |> Enum.min_by(fn val -> val[:A] end)
    |> Map.get(:A)
  end
end

# This returns 6,060,803, which is the WRONG answer
# That's not the right answer; your answer is too low.

# After debugging: 47909639, which is the RIGHT answer
