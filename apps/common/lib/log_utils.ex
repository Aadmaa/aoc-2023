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


  #
  # CREDIT for map_put and many_map_puts:
  # jonericcook -
  # https://elixirforum.com/t/put-update-deep-inside-nested-maps-and-auto-create-intermediate-keys/7993/12%20%20
  #
  def map_put(data, keys, value) do
    # data = %{} or non empty map
    # keys = [:a, :b, :c]
    # value = 3
    put_in(data, Enum.map(keys, &Access.key(&1, %{})), value)
  end

  def many_map_puts(data, keys_values) do
    # data = %{} or non empty map
    # keys_values = [[keys: [:a, :b, :c], value: 4],[keys: [:z, :y, :x], value: 90]]
    Enum.reduce(keys_values, data, fn x, data ->
      map_put(data, x[:keys], x[:value])
    end)
  end

# iex(1)> m = [[keys: [:a, :b, :c], value: 4],[keys: [:z, :y, :x], value: 90]]
# [[keys: [:a, :b, :c], value: 4], [keys: [:z, :y, :x], value: 90]]
# iex(2)> many_map_puts(%{}, m)
# %{a: %{b: %{c: 4}}, z: %{y: %{x: 90}}}

end
