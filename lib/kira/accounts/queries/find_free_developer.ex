defmodule Kira.Accounts.Queries.FindFreeDeveloper do
  @moduledoc """
  Finds users that are not assigned to any issues
  """

  use Exop.Operation

  alias Kira.Accounts.Entities.User
  alias Kira.Accounts.Queries.UserQueries
  alias Kira.Projects.Queries.ProjectQueries

  def process(%{project_uid: project_uid}) do
    project = ProjectQueries.get_project!(project_uid)

    users =
      User
      |> UserQueries.not_assigned_within_project(project)
      |> Kira.Repo.all()

    {:ok, %{users: users}}
  end
end
