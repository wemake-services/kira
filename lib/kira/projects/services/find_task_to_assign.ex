defmodule Kira.Projects.Services.FindTaskToAssign do
  @moduledoc """
  Returns an open task with no assignee.
  """

  use Exop.Operation

  alias Kira.Projects.Queries.IssueQueries
  alias Kira.Projects.Queries.ProjectQueries

  parameter(:project_uid, type: :integer)

  def process(%{project_uid: project_uid}) do
    project = ProjectQueries.get_project!(project_uid)

    issue =
      Issue
      |> IssueQueries.for_project(project)
      |> IssueQueries.open()
      |> IssueQueries.with_no_assignee()
      |> IssueQueries.with_highest_priority()

    %{entity: issue}
  end
end
