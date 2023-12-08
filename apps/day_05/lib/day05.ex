defmodule Day05 do
  @moduledoc """
  `Day05 - see description in AoC`
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

  defp proc_seed_one_step(data, seed, step) do

      %{ xforms: xf } = data

      f = Map.filter(xf, fn { _key, val } -> val.step == step end)
      [name] = Map.keys(f)
      ranges = f[name][:values]

      translator = Enum.find(ranges, nil, fn range ->
        %{ dest: _dest, src: src, len: len } = range
        seed >= src and seed <= (src + len - 1)
       end)

       if translator == nil do
         seed
       else
        %{ dest: dest, src: src, len: _len } = translator
        seed - (src - dest)
       end

  end

  defp proc_seed_all_steps(data, seed) do
    step_count = data.current_step

    Enum.reduce(1..step_count, seed, fn step, acc ->
         proc_seed_one_step(data, acc, step)
    end)
  end

  defp proc_seeds(data) do
    Enum.map(data.seeds, fn seed ->
        # logg("Seed: #{seed}")
        rez = proc_seed_all_steps(data, seed)
        # logg("#{seed} ->",rez)
        rez
    end)
  end


  @spec main(
          binary()
          | maybe_improper_list(
              binary() | maybe_improper_list(any(), binary() | []) | char(),
              binary() | []
            )
        ) :: list()
  def main(filename) do
    file_stream = File.stream!(Path.absname(filename))

    file_stream
    |> Stream.map(&String.trim/1)                         # Remove leading or trailing spaces
    |> Stream.map(&String.replace(&1, ~r/\s+/, " "))      # Replace any multiple spaces with single spaces
    |> Enum.to_list()
    |> map_data
    |> proc_seeds
    |> Enum.min
  end
end

# This returns 226172555, which is the right answer
