defmodule Common.LogUtils do
  @moduledoc """
  Documentation for `Utils`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Utils.hello()
      :world

  """
  def logg(text, data \\ nil, suppress \\ false) do
    if !suppress do
      IO.puts("#{IO.ANSI.light_blue()}#{text}")
      IO.puts(IO.ANSI.reset())
      if data do
        IO.inspect(data, charlists: false)
      end
    end
  end

    # Splits a range into "buckets"
  def split_range(interval, buckets) do
    bucket_size = floor(interval / buckets)
    extras = rem(interval, bucket_size)
    # [4 | list]
    Enum.reduce(1..buckets, [], fn i, acc ->
      # Extras will go in the last bucket
      use_extras = if i == buckets, do: extras, else: 0
      [[ (i - 1) * bucket_size + 1, i * bucket_size + use_extras ] | acc]
    end)
  end


end
