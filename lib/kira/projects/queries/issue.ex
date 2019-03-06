defmodule Kira.Projects.Queries.IssueQueries do
  @moduledoc """
  Reading queries that do not modify state of `Issue`s.
  """

  import Ecto.Query, warn: false
  alias Kira.Repo

  alias Kira.Projects.Entities.Issue

  def get_issue!(uid) do
    Issue
    |> Repo.get_by!(uid: uid)
  end
end
