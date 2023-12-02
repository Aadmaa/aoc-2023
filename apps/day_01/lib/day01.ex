defmodule Day01 do
  @moduledoc """
  `Day01` - Get the first and last digits from each line, 
  convert them to integers and total them.
  If there's just one digit it gets used twice.
  """

  defp get_digits(line) do
    Regex.replace(~r/\D/, line, "")
  end

  defp countem([]), do: 0
  defp countem([head|tail]) do 
    digits = get_digits(head)
    a = String.at(digits, 0) 
    b = String.reverse(digits)
      |> String.at(0) 
    String.to_integer(a <> b) + countem(tail)
  end

  def main(filename) do
    File.stream!(Path.absname(filename), [:read]) 
      |> Stream.map(&String.trim/1)
      |> Enum.to_list()
      |> countem
  end

end
