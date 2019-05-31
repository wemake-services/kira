defmodule Kira.Common.MapUtils do
  @moduledoc """
    Here are utilities for manipulations with map keys that are required for
    different contexts.
  """

  @doc """
    A helper that transforms map keys from strings to existing atoms.
  """
  def atomize_keys(dict) do
    Map.new(dict, fn {k, v} -> {String.to_existing_atom(k), v} end)
  end

  @doc """
    A helper that transforms map keys from atoms to strings.
  """
  def stringify_keys(dict) do
    Map.new(dict, fn {k, v} -> {Atom.to_string(k), v} end)
  end
end
