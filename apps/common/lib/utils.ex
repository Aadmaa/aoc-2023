defmodule LogUtils do
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
      if data do
        IO.inspect(data, charlists: false)
      end
    end
  end

end
