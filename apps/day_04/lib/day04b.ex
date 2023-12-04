defmodule Day04B do
  @moduledoc """
  Left hand list of numbers are Winners.
  Right hand list are My Guesses.
  Count the correct guesses on each line
  This is the number of "Winners"
  Now, traversing the list of cards with the number of Winners for each card in mind,
  you get to keep the original Card. THen if you have, say, 3 winners, you get to make copies of the
  next 3 cards in the list.

  Copies which have winners also make their own copies. (See problem description at AoC)

  The final answer is the total number of cards you end up with.
  """

  #
  # Returns a dictionary with keys as Card Id, and value as the number of copies of that card
  defp process_winners_list(winners_list) do
    Enum.reduce(winners_list, {%{}, 1}, fn winner_count, {result_map, index} ->
      # winner_count is the number of winners on the row.
      # Index is the Card number (which starts at 1)

      # Now if we have A cards a the index, and 4 winners, and B is the number we have at index+1, etc:
      # A' = A + 1
      # B' = B + A'
      # C' = C + A'
      # D' = D + A'

      # First, add one copy of the card at the index - this is the original card
      rez = Map.update(result_map, index, 1, fn existing_value -> existing_value + 1 end)
      final_cards_at_index = rez[index]

      rez_final =  if winner_count > 0 do
        Enum.reduce(1..winner_count, rez, fn i, acc ->
          # Looking ahead, we add A' to the current value
          Map.update(acc, index+i, final_cards_at_index, fn existing_value -> existing_value + final_cards_at_index end)
        end)
      else
        rez
      end

      { rez_final, index + 1 }
    end
    )
    |> elem(0)
  end

  # Counts winners from guesses and list of winning numbers
  defp count_winners(winners, mine) do
    length(
      Enum.filter(mine, fn item ->
        Enum.find(winners, &(&1 == item)) != nil
      end)
    )
  end


  def main(filename) do
    file_stream = File.stream!(Path.absname(filename))

    file_stream
    |> Stream.map(&String.trim/1)
    # Replace multiple spaces with just one space (eg "x    y" => "x y")
    |> Stream.map(&String.replace(&1, ~r/\s+/, " "))
    # |> Enum.map(&IO.inspect/1)
    |> Stream.map(&String.split(&1, ~r/[:|]/))
    |> Stream.map(fn [_game, winners, mine] -> [String.trim(winners), String.trim(mine)] end)
    |> Stream.map(fn [winners, mine] -> [String.split(winners, " "), String.split(mine, " ")] end)
    # Now we have two lists of strings that are the winners. Let's keep the ones on the right that match the left
    |> Stream.map(fn [winners, mine] -> count_winners(winners, mine) end)
    # The list now has a count of winning numbers that is found on each row
    # Let's use a function to turn that into a Map showing the number of Cards won for each Card Id
    |> process_winners_list
    # Sum the number of cards that we won total
    |> Enum.reduce(0, fn {_key, card_count}, acc -> acc + card_count end)
  end
end

# This returns 14624680, which is the right answer
