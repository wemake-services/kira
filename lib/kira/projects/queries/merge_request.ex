defmodule Kira.Projects.Queries.MergeRequestQueries do
  @moduledoc """
  Reading queries that do not modify state of `MergeRequest`s.
  """

  import Ecto.Query, warn: false
  alias Kira.Repo

  alias Kira.Projects.Entities.MergeRequest

  def get_merge_request!(uid) do
    MergeRequest
    |> Repo.get_by!(uid: uid)
  end
end
