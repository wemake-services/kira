defmodule Kira.Common.TimeUtils do
  @moduledoc """
  Different time utils that are required for different contexts.
  """

  @doc """
  Returns current time. Truncates it to the given unit if given.
  """
  def current_time do
    NaiveDateTime.utc_now()
  end

  def current_time(limit) when is_atom(limit) do
    NaiveDateTime.truncate(current_time(), limit)
  end

  @doc """
  Adds `:inserted_at` and `:updated_at` atom keys to the enitity map.
  """
  def enrich_with_timestamps(%{} = entity) do
    entity
    |> Map.put(:inserted_at, current_time(:second))
    |> Map.put(:updated_at, current_time(:second))
  end
end
