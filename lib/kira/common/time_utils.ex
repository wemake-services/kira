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

  @doc """
  Parses gitlab-specific time format.

  Example:
    iex(3)> Kira.Common.TimeUtils.from_gitlab_timeformat!(
    ...(3)>   "2019-03-09 16:50:55 UTC"
    ...(3)> )
    ~N[2019-03-09 16:50:55]

  """
  def from_gitlab_timeformat!(timestamp) do
    Timex.parse!(timestamp, "{YYYY}-{0M}-{0D} {h24}:{m}:{s} UTC")
  end

  @doc """
  Creates gitlab-specific time format.

  Example:
    iex(3)> Kira.Common.TimeUtils.to_gitlab_timeformat!(
    ...(3)>   ~N[2019-03-09 16:50:55]
    ...(3)> )
    "2019-03-09 16:50:55 UTC"

  """
  def to_gitlab_timeformat!(datetime) do
    Timex.format!(datetime, "{YYYY}-{0M}-{0D} {0h24}:{m}:{s} UTC")
  end
end
