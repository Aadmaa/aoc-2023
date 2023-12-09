defmodule Day07B do
  @moduledoc """
  Documentation for `Day07B`.

  7  Five of a kind, where all five cards have the same label: AAAAA
  6  Four of a kind, where four cards have the same label and one card has a different label: AA8AA
  5  Full house, where three cards have the same label, and the remaining two cards share a different label: 23332
  4  Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand: TTT98
  3  Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label: 23432
  2  One pair, where two cards share one label, and the other three cards have a different label from the pair and each other: A23A4
  1  High card, where all cards' labels are distinct: 23456

  For "B", J's are Jokers. They are the lowest card type for tiebreakers -- only

  Examples
  iex

  c "../common/lib/log_utils.ex"
  c "lib/day07.ex"
  Day07.main("data/testdata.txt")

  """

  import Common.LogUtils

  # A, K, Q, J, T, 9, 8, 7, 6, 5, 4, 3, or 2
  def card_value(card) do
    cond do
      card == "A" -> 14
      card == "K" -> 13
      card == "Q" -> 12
      card == "J" ->  1  # Now J is lower than 2, for tiebreakers
      card == "T" -> 10
      true -> String.to_integer(card)
    end
  end

  defp freq_at(freq, index) do
    Enum.at(freq, index) |> Enum.at(1)
  end

  # [[card, freq], [card, freq] ...], sorted by frequencies DESC, then card value DESC
  def merge_J_to_freq(list) do
    no_j = Enum.filter(list, &(Enum.at(&1, 0)) != "J")
    the_j = List.flatten(Enum.filter(list, &(Enum.at(&1, 0)) == "J"))
    # Get the number of jokers
    j_count = if length(the_j) == 2, do: Enum.at(the_j,1), else: 0

    # If they are all jokers!
    if j_count == 5 do
      [['A' | 5]]
    else
      # Otherwise add them the best card we have, which is already leftmost
      [ [best_card | [best_count]] | rest ] = no_j

      [ [ best_card, best_count + j_count ] | rest ]
    end
  end


  def get_hand_value(hand) do

    cards = String.graphemes(hand)
    # These are the tiebreaker values
    card_values = cards |> Enum.map(&card_value(&1))

    # Get array [[card, freq], [card, freq] ...], sorted by freq desc
    freq_original =
      Enum.frequencies(cards)
      |> Enum.map(fn {k, v} -> [k, v] end)
      |> Enum.sort(fn a, b ->
        if Enum.at(a, 1) != Enum.at(b, 1) do
          Enum.at(a, 1) > Enum.at(b, 1)
        else
          card_value(Enum.at(a, 0)) > card_value(Enum.at(b, 0))
        end
      end)

    # Merge jokers to their optimal card
    freq = merge_J_to_freq(freq_original)

    main_val = cond do
      # { 7, 12, 0 } would be a hand of "AAAAA" because the hand value is 7 and the first tiebreaker is the card value 12

      # 5 of a kind hsa just one card value
      length(freq) == 1 -> 7
      # 4 of a kind
      freq_at(freq, 0) == 4 -> 6
      # Full house: two types of cards remaining (and 4 of a kind)
      length(freq) == 2 -> 5
      # Three of a kind
      freq_at(freq, 0) == 3 -> 4
      # Two pair
      freq_at(freq, 0) == 2 and freq_at(freq, 1) == 2 -> 3
      # One pair
      freq_at(freq, 0) == 2 -> 2
      true -> 1
    end

    get_hand_value_from_list([main_val | card_values])

  end


  def get_hand_value_from_list(list) do
    # logg("hand_value", hand_value)
    # logg("hand_value, 0", elem(hand_value,0))

    Enum.reduce(0..length(list)-1, "", fn
      i, acc ->
        acc <> String.pad_leading("#{Enum.at(list, i)}", 3, "0") <> "_"
      end)
  end

  def main(filename) do
    file_stream = File.stream!(Path.absname(filename))

    file_stream
    # Remove leading or trailing spaces
    |> Stream.map(&String.trim/1)
    # Replace any multiple spaces with single spaces
    |> Stream.map(&String.replace(&1, ~r/\s+/, " "))
    |> Stream.map(&String.split(&1, " "))
    |> Stream.map(fn [hand, bid] -> %{hand: hand, bid: String.to_integer(bid)} end)
    |> Stream.map(fn %{hand: hand, bid: bid} -> %{ hand: hand, bid: bid, hand_value: get_hand_value(hand)} end)
    |> Enum.sort(fn a, b -> a.hand_value < b.hand_value end)
    |> Stream.with_index(1)
    |> Enum.to_list()
    |> Enum.map(fn {%{bid: bid, hand: hand, hand_value: hand_value}, rank } -> %{ hand: hand, bid: bid, hand_value: hand_value, total_value: bid * rank} end)
    # |> Enum.map(&IO.inspect/1)
    |> Enum.map(fn val -> val.total_value end)
    |> Enum.sum
  end
end

# Got 250946742 which is the correct answer
