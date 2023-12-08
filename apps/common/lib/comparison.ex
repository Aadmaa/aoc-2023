defmodule Common.Comparison do
  @moduledoc """
  Documentation for `Comparison`.
  """

  @default_equality_options %{
    strict: false,
    list_order_irrelevant: false
  }

  defp get_options_map(options) do
    Enum.into(options, @default_equality_options)
  end

  # Returns the "strict" option
  defp option_strict(options) do
    %{strict: strict, list_order_irrelevant: _} = get_options_map(options)
    strict
  end

  # Returns relevant list sorting options
  defp option_list_order_irrelevant(options) do
    %{strict: _, list_order_irrelevant: list_order_irrelevant} =
      get_options_map(options)

    list_order_irrelevant
  end

  defp equality_checker_type(a) do
    cond do
      is_function(a) -> raise("Can't check functions for equality")
      Enumerable.impl_for(a) == Enumerable.Map -> :map
      Enumerable.impl_for(a) == Enumerable.List -> :list
      true -> :scalar
    end
  end

  # Sorts a list, respecting the options
  defp sort_list(a, options) do
    list_order_irrelevant = option_list_order_irrelevant(options)
    cond do
      !list_order_irrelevant -> a
      true -> Enum.sort(a)
    end
  end


  @doc """
  check_equality(a, b, options \\ []), using a hash mechanism recursively
  It can handle lists of maps without any sort options

  Options are passed in a list. E.g., [strict: true]

  - strict: boolean (default is false)
  - list_order_irrelevant: boolean  (default is false, which means any lists have to match in the order that they are already in)

    Note that if there are nested lists, the same sort rules and function
    will be applied. If that does not work, sort them in advance, and
    then set list_order_irrelevant to false.
  """
  def is_equal(a, b, options \\ []) do
    hash_a = make_comparable(a, options)
    hash_b = make_comparable(b, options)

    # Use exact equality because scalars comparisons return the scalars, not hashes
    # But they convert integer to float if strict is off
    hash_a === hash_b
  end




  # Reduces a map to an Erlang hash, using recursion to
  # respect sort and strictness options
  defp make_map_comparable(a, options) do

      keys = Map.keys(a)

      Enum.reduce(keys, %{}, fn key, acc ->
        # Keys can have any type. We'll apply the same options in hashing the key
        comparable_key = make_comparable(key, options)
        comparable_value = make_comparable(a[key], options)

        # Add to the new, comparable map
        Map.put(acc, comparable_key, comparable_value)
      end)

      # After recursion I have a map that just has hashes in it for both keys and values.
      # I can safely hash that and return a value
      |> (&(:erlang.phash2({&1, "MAP"}))).()

  end

  # Reduces a list to an Erlang hash, using recursion to
  # respect sort and strictness options
  defp make_list_comparable(a, options) do
    # make inner lists or maps comparable
    Enum.map(a,
      fn item ->
        make_comparable(item, options)
      end
    )
    # Sort, respecting sort options
    |> sort_list(options)
    # Return the hash of the list
    |> (&(:erlang.phash2({&1, "LIST"}))).()
  end

  # Scalars are comparable unless strict is true, and one is an integer, in which case we
  #   convert it to a float
  defp make_scalar_comparable(a, options) do
    strict = option_strict(options)
    cond do
      strict -> a
      is_integer(a) -> a * 1.0
      true -> a
    end
    |> (&(:erlang.phash2({&1, "SCALAR"}))).()
  end

  # Make two nested structures comparable, returning a numerical hash
  defp make_comparable(a, options) do

    eq_type = equality_checker_type(a)

    cond do
      eq_type == :scalar -> make_scalar_comparable(a, options)
      eq_type == :map -> make_map_comparable(a, options)
      eq_type == :list -> make_list_comparable(a, options)
    end

  end
end
