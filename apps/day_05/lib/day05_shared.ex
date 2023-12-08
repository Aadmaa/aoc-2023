defmodule Day05Shared do

  @logglevel 0

  def logg(text, data \\ nil, level \\ 0) do
    if level >= @logglevel do
      IO.puts("LOG #{text}")

      if data do
        IO.inspect(data, charlists: false)
      end
    end
  end

    # Get seeds from seed line
    defp get_seeds(line) do
      ["seeds", value_line] = String.split(line, ":")

      # IO.puts("value_line: #{value_line}")

      String.split(String.trim(value_line), " ")
        # |> Enum.map(&IO.inspect/1)
        |> Enum.map(&String.to_integer/1)
    end

    # Starting point: no accumulator. Create accumulator and get the "seeds"
    def map_data([head | tail]) do
      acc = %{
        seeds: get_seeds(head),
        xforms: %{},
        current_xform: "seeds",
        current_step: 0
      }

      map_data( tail, acc )
    end

    defp map_data([head | tail], acc) do

      acc = cond do
        # Skip any blank lines
        head == "" -> acc
        String.last(head) == ":" -> proc_headerline(head, acc)
        true -> proc_dataline(head, acc)
       end

      map_data( tail, acc )
    end

    defp map_data([], acc) do
      acc
    end


    # New transformation header
    defp proc_headerline(line, acc) do

      # Get new xform step number
      current_step = Map.get(acc, :current_step) + 1

      # New xform name
      [xform_name, _] = String.split(line, " ")

      new_data = %{
        values: [],
        step: current_step
      }

       acc =
          Map.put(acc, :current_xform, xform_name)
          |> Map.put(:current_step, current_step)

        acc = put_in(acc, [:xforms, xform_name], new_data)

        acc
    end

    # New transformation data line
    defp proc_dataline(line, acc) do

      # Name of the xform we are currently collecting xform data for
      xform_name = Map.get(acc, :current_xform)

      [dest, src, len] =
        String.split(line, " ")
        |> Enum.map(&String.to_integer/1)

      update_in(acc, [:xforms, xform_name, :values],
        fn old_values ->  [ %{ dest: dest, src: src, len: len } | old_values] end)
      |> update_in([:xforms, xform_name, :step], fn _ -> acc.current_step end)

    end

end
