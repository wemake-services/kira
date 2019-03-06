defmodule Kira.Projects.Commands.CreateIssue do
  @moduledoc """
  Persistant command to create a new `Issue`.
  """

  use Exop.Operation

  alias Kira.Projects.Entities.Issue
  alias Kira.Projects.Queries.ProjectQueries
  alias Kira.Repo

  parameter(:project_uid, type: :integer)
  parameter(:attrs, type: :map)

  def process(%{attrs: attrs, project_uid: project_uid}) do
    project = ProjectQueries.get_project!(project_uid)
    attrs = Map.put(attrs, "project_id", project.id)

    issue =
      %Issue{}
      |> Issue.changeset(attrs)
      |> Ecto.Changeset.put_assoc(:project, project)
      |> Repo.insert!()

    %{entity: issue}
  end
end
