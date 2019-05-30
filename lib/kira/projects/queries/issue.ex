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
  def queued(query) do
    query |> where([i], i.state == "queued")
  end

  @doc """
  Selects issues for particular project.
  """
  def for_project(query, project) do
    from i in query,
      join: p in assoc(i, :project),
      where: p.id == ^project.id
  end

  @doc """
  Selects issues with no assignee.
  """
  def with_no_assignee(query) do
    query |> where([i], is_nil(i.assignee_id))
  end

  @doc """
  Selects an issue with the highest priority.
  """
  def with_highest_priority(query) do
    query
    |> first(desc: :weight)
    |> Repo.one()
  end
end
