defmodule Kira.Projects.Queries.IssueQueries do
  @moduledoc """
  Reading queries that do not modify state of `Issue`s.
  """

  import Ecto.Query, warn: false
  alias Kira.Repo

  alias Kira.Projects.Entities.Issue

  @doc """
  Gets issue by third-party id.
  """
  def get_issue!(uid) do
    Issue
    |> Repo.get_by!(uid: uid)
  end

  @doc """
  Selects open issues.
  """
  def open(query) do
    query |> where([i], i.state == 'open')
  end

  @doc """
  Selects issues for particular project.
  """
  def for_project(query, project) do
    from i in query,
      join: p in assoc(i, :project),
      where: p.id == ^project.id
  end

  def with_highest_priority(query) do
    # TODO: implement prioritizing
    query |> first
  end
end
